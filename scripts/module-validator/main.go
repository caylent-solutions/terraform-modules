package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// Colors for terminal output
const (
	ColorReset  = "\033[0m"
	ColorRed    = "\033[31m"
	ColorGreen  = "\033[32m"
	ColorYellow = "\033[33m"
	ColorBlue   = "\033[34m"
)

func main() {
	modulePath := flag.String("module-path", "", "Path to the Terraform module")
	moduleType := flag.String("module-type", "", "Type of the Terraform module (utility, collection, reference, etc.)")
	configPath := flag.String("config", "", "Path to the monorepo configuration file")
	flag.Parse()

	if *modulePath == "" {
		fmt.Printf("%sError: Module path is required%s\n", ColorRed, ColorReset)
		os.Exit(1)
	}

	if *moduleType == "" {
		fmt.Printf("%sError: Module type is required%s\n", ColorRed, ColorReset)
		os.Exit(1)
	}

	if *configPath == "" {
		fmt.Printf("%sError: Config path is required%s\n", ColorRed, ColorReset)
		os.Exit(1)
	}

	// Load configuration
	config, err := loadConfig(*configPath)
	if err != nil {
		fmt.Printf("%sError loading configuration: %v%s\n", ColorRed, err, ColorReset)
		os.Exit(1)
	}

	// Get scripts configuration
	scripts, ok := config["scripts"].(map[string]interface{})
	if !ok {
		fmt.Printf("%sError: scripts configuration not found%s\n", ColorRed, ColorReset)
		os.Exit(1)
	}

	// Get temp file pattern
	tempFilePattern, ok := scripts["temp_file_pattern"].(string)
	if !ok {
		tempFilePattern = "terraform-files-*.json" // Fallback
	}

	// Get terraform file collector script
	tfCollectorScript, ok := scripts["terraform_file_collector"].(string)
	if !ok {
		fmt.Printf("%sError: terraform_file_collector script not found in config%s\n", ColorRed, ColorReset)
		os.Exit(1)
	}

	// Create temporary file for Terraform files
	tempFile, err := ioutil.TempFile("", tempFilePattern)
	if err != nil {
		fmt.Printf("%sError creating temporary file: %v%s\n", ColorRed, err, ColorReset)
		os.Exit(1)
	}
	defer os.Remove(tempFile.Name())
	tempFile.Close()

	// Collect Terraform files
	cmd := exec.Command("go", "run", tfCollectorScript,
		"--module-path", *modulePath,
		"--output", tempFile.Name())
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		fmt.Printf("%sError collecting Terraform files: %v%s\n", ColorRed, err, ColorReset)
		os.Exit(1)
	}

	// Determine policy directory based on module type
	moduleTypes, ok := config["module_types"].(map[string]interface{})
	if !ok {
		fmt.Printf("%sError: module_types not found in config%s\n", ColorRed, ColorReset)
		os.Exit(1)
	}

	typeConfig, ok := moduleTypes[*moduleType].(map[string]interface{})
	if !ok {
		fmt.Printf("%sNo specific policies for module type: %s%s\n", ColorYellow, *moduleType, ColorReset)
		os.Exit(0)
	}

	policyDir, ok := typeConfig["policy_dir"].(string)
	if !ok {
		fmt.Printf("%sNo policy directory defined for module type: %s%s\n", ColorYellow, *moduleType, ColorReset)
		os.Exit(0)
	}

	// Run OPA evaluation
	fmt.Printf("%s=== Evaluating module type policies for %s module ===%s\n", ColorBlue, *moduleType, ColorReset)
	
	policyFiles, err := filepath.Glob(filepath.Join(policyDir, "*.rego"))
	if err != nil {
		fmt.Printf("%sError finding policy files: %v%s\n", ColorRed, err, ColorReset)
		os.Exit(1)
	}

	if len(policyFiles) == 0 {
		fmt.Printf("%sNo policy files found in %s%s\n", ColorYellow, policyDir, ColorReset)
		os.Exit(0)
	}

	// Evaluate each policy
	violations := false
	for _, policyFile := range policyFiles {
		policyName := filepath.Base(policyFile)
		fmt.Printf("Evaluating policy: %s\n", policyName)

		// Determine package name from policy file
		packageName := getPackageName(policyFile)
		if packageName == "" {
			fmt.Printf("%sError: Could not determine package name for %s%s\n", ColorRed, policyFile, ColorReset)
			violations = true
			continue
		}

		// Run OPA evaluation
		cmd := exec.Command("opa", "eval", "--format", "json", "--data", policyFile, 
			"data."+packageName+".violation", "--input", tempFile.Name())
		output, err := cmd.CombinedOutput()

		if err != nil {
			fmt.Printf("%sError evaluating policy %s: %v%s\n", ColorRed, policyName, err, ColorReset)
			fmt.Println(string(output))
			violations = true
			continue
		}

		// Parse results
		var result map[string]interface{}
		if err := json.Unmarshal(output, &result); err != nil {
			fmt.Printf("%sError parsing policy results: %v%s\n", ColorRed, err, ColorReset)
			continue
		}

		// Check for violations
		if results, ok := result["result"].([]interface{}); ok && len(results) > 0 {
			violations = true
			fmt.Printf("%s✗ Policy violations found in %s%s\n", ColorRed, policyName, ColorReset)
			
			for _, r := range results {
				if violation, ok := r.(map[string]interface{}); ok {
					fmt.Printf("  %s%s%s\n", ColorRed, violation["message"], ColorReset)
					fmt.Printf("  Details: %s\n", violation["details"])
					fmt.Printf("  Resolution: %s\n\n", violation["resolution"])
				}
			}
		} else {
			fmt.Printf("%s✓ No violations in %s%s\n", ColorGreen, policyName, ColorReset)
		}
	}

	if violations {
		fmt.Printf("%s=== Module type policy check failed ===%s\n", ColorRed, ColorReset)
		os.Exit(1)
	} else {
		fmt.Printf("%s=== All module type policy checks passed ===%s\n", ColorGreen, ColorReset)
	}
}

// loadConfig loads the configuration from a JSON file
func loadConfig(path string) (map[string]interface{}, error) {
	data, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("failed to read config file: %w", err)
	}

	var config map[string]interface{}
	if err := json.Unmarshal(data, &config); err != nil {
		return nil, fmt.Errorf("failed to parse config file: %w", err)
	}

	return config, nil
}

// getPackageName extracts the package name from a Rego file
func getPackageName(policyFile string) string {
	data, err := ioutil.ReadFile(policyFile)
	if err != nil {
		return ""
	}

	content := string(data)
	lines := strings.Split(content, "\n")
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if strings.HasPrefix(line, "package ") {
			packageName := strings.TrimPrefix(line, "package ")
			return packageName
		}
	}

	return ""
}
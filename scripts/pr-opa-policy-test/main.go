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

// PolicyInput represents the input structure for OPA policies
type PolicyInput struct {
	ChangedFiles []string               `json:"changed_files"`
	Config       map[string]interface{} `json:"config"`
}

// PolicyResult represents a policy violation result
type PolicyResult struct {
	Policy     string `json:"policy"`
	Severity   string `json:"severity"`
	Message    string `json:"message"`
	Details    string `json:"details"`
	Resolution string `json:"resolution"`
}

// PolicyOutput represents the output structure from OPA evaluation
type PolicyOutput struct {
	Result []PolicyResult `json:"result"`
}

func main() {
	configPath := flag.String("config", "", "Path to the monorepo configuration file")
	policyDir := flag.String("policy-dir", "", "Directory containing OPA policy files")
	flag.Parse()

	// Validate input
	if *configPath == "" {
		fmt.Printf("%sError: Configuration file path is required. Use --config flag to specify the path.%s\n", ColorRed, ColorReset)
		os.Exit(1)
	}

	if *policyDir == "" {
		fmt.Printf("%sError: Policy directory is required. Use --policy-dir flag to specify the path.%s\n", ColorRed, ColorReset)
		os.Exit(1)
	}

	// Load configuration
	config, err := loadConfig(*configPath)
	if err != nil {
		fmt.Printf("%sError loading configuration: %v%s\n", ColorRed, err, ColorReset)
		os.Exit(1)
	}

	// Get changed files (in a real CI environment, this would come from git)
	changedFiles := getChangedFiles(config)

	// Prepare input for OPA
	input := PolicyInput{
		ChangedFiles: changedFiles,
		Config:       config,
	}

	// Evaluate policies
	fmt.Printf("%s=== Evaluating PR policies ===%s\n", ColorBlue, ColorReset)
	evaluatePolicies(input, *policyDir)
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

// getChangedFiles gets the list of changed files from the configuration or git
func getChangedFiles(config map[string]interface{}) []string {
	// For testing, use files from config if provided
	if files, ok := config["test_changed_files"].([]interface{}); ok && len(files) > 0 {
		changedFiles := make([]string, len(files))
		for i, file := range files {
			changedFiles[i] = file.(string)
		}
		return changedFiles
	}

	// In a real environment, get changed files from git
	// This is a simplified example - in a real CI environment, you'd compare against the base branch
	cmd := exec.Command("git", "diff", "--name-only", "HEAD~1", "HEAD")
	output, err := cmd.Output()
	if err != nil {
		fmt.Printf("%sWarning: Failed to get changed files from git: %v%s\n", ColorYellow, err, ColorReset)
		return []string{}
	}

	files := strings.Split(strings.TrimSpace(string(output)), "\n")
	return files
}

// evaluatePolicies evaluates all OPA policies against the input
func evaluatePolicies(input PolicyInput, policyDir string) {
	// Convert input to JSON
	inputJSON, err := json.Marshal(input)
	if err != nil {
		fmt.Printf("%sError marshaling input: %v%s\n", ColorRed, err, ColorReset)
		os.Exit(1)
	}

	// Get policy files
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

		// Run OPA evaluation
		cmd := exec.Command("opa", "eval", "--format", "json", "--data", policyFile, 
			"data."+strings.Replace(strings.TrimSuffix(filepath.Base(policyFile), ".rego"), "_", ".", -1)+".violation")
		cmd.Stdin = strings.NewReader(string(inputJSON))
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
		fmt.Printf("%s=== Policy check failed ===%s\n", ColorRed, ColorReset)
		os.Exit(1)
	} else {
		fmt.Printf("%s=== All policy checks passed ===%s\n", ColorGreen, ColorReset)
	}
}
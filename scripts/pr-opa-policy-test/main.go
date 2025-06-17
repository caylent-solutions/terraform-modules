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
	policyDirs := flag.String("policy-dirs", "", "Comma-separated list of directories containing OPA policy files")
	featureBranch := flag.String("feature-branch", "", "Feature branch commit or reference")
	primaryBranch := flag.String("primary-branch", "main", "Primary branch to merge into (default: main)")
	flag.Parse()

	// Validate input
	if *configPath == "" {
		fmt.Printf("%sError: Configuration file path is required. Use --config flag to specify the path.%s\n", ColorRed, ColorReset)
		os.Exit(1)
	}

	if *policyDirs == "" {
		fmt.Printf("%sError: Policy directories are required. Use --policy-dirs flag to specify comma-separated paths.%s\n", ColorRed, ColorReset)
		os.Exit(1)
	}

	if *featureBranch == "" {
		fmt.Printf("%sError: Feature branch is required. Use --feature-branch flag to specify the branch.%s\n", ColorRed, ColorReset)
		os.Exit(1)
	}

	// Load configuration
	config, err := loadConfig(*configPath)
	if err != nil {
		fmt.Printf("%sError loading configuration: %v%s\n", ColorRed, err, ColorReset)
		os.Exit(1)
	}

	// Get changed files between feature branch and primary branch
	changedFiles := getChangedFiles(*featureBranch, *primaryBranch, config)

	// Prepare input for OPA
	input := PolicyInput{
		ChangedFiles: changedFiles,
		Config:       config,
	}

	// Split policy directories
	dirs := strings.Split(*policyDirs, ",")

	// Evaluate policies from all directories
	fmt.Printf("%s=== Evaluating PR policies ===%s\n", ColorBlue, ColorReset)
	
	violations := false
	for _, dir := range dirs {
		dir = strings.TrimSpace(dir)
		if dir == "" {
			continue
		}
		
		fmt.Printf("Checking policies in directory: %s\n", dir)
		if hasViolations := evaluatePolicies(input, dir); hasViolations {
			violations = true
		}
	}

	if violations {
		fmt.Printf("%s=== Policy check failed ===%s\n", ColorRed, ColorReset)
		os.Exit(1)
	} else {
		fmt.Printf("%s=== All policy checks passed ===%s\n", ColorGreen, ColorReset)
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

// getChangedFiles gets the list of changed files between feature branch and primary branch
func getChangedFiles(featureBranch, primaryBranch string, config map[string]interface{}) []string {
	// For testing, use files from config if provided
	if files, ok := config["test_changed_files"].([]interface{}); ok && len(files) > 0 {
		changedFiles := make([]string, len(files))
		for i, file := range files {
			changedFiles[i] = file.(string)
		}
		return changedFiles
	}

	// Get the merge-base (common ancestor) of the two branches
	mergeBaseCmd := exec.Command("git", "merge-base", primaryBranch, featureBranch)
	mergeBase, err := mergeBaseCmd.Output()
	if err != nil {
		fmt.Printf("%sWarning: Failed to find merge-base: %v%s\n", ColorYellow, err, ColorReset)
		return []string{}
	}
	
	// Get changed files that would be merged
	cmd := exec.Command("git", "diff", "--name-only", strings.TrimSpace(string(mergeBase)), featureBranch)
	output, err := cmd.Output()
	if err != nil {
		fmt.Printf("%sWarning: Failed to get changed files from git: %v%s\n", ColorYellow, err, ColorReset)
		return []string{}
	}

	if len(output) == 0 {
		fmt.Printf("%sNo changed files detected between %s and %s%s\n", 
			ColorYellow, primaryBranch, featureBranch, ColorReset)
		return []string{}
	}

	files := strings.Split(strings.TrimSpace(string(output)), "\n")
	return files
}

// evaluatePolicies evaluates all OPA policies in a directory against the input
// Returns true if violations were found
func evaluatePolicies(input PolicyInput, policyDir string) bool {
	// Convert input to JSON
	inputJSON, err := json.Marshal(input)
	if err != nil {
		fmt.Printf("%sError marshaling input: %v%s\n", ColorRed, err, ColorReset)
		return true
	}

	// Get policy files
	policyFiles, err := filepath.Glob(filepath.Join(policyDir, "*.rego"))
	if err != nil {
		fmt.Printf("%sError finding policy files: %v%s\n", ColorRed, err, ColorReset)
		return true
	}

	if len(policyFiles) == 0 {
		fmt.Printf("%sNo policy files found in %s%s\n", ColorYellow, policyDir, ColorReset)
		return false
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

	return violations
}
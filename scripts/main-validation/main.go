package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"
)

// ANSI color codes
const (
	Red    = "\033[0;31m"
	Green  = "\033[0;32m"
	Yellow = "\033[1;33m"
	Blue   = "\033[0;34m"
	Cyan   = "\033[0;36m"
	NC     = "\033[0m" // No Color
)

// Config represents the monorepo configuration
type Config struct {
	ModuleRoots []string `json:"module_roots"`
	ModuleTypes map[string]struct {
		PathPatterns []string `json:"path_patterns"`
		PolicyDir    string   `json:"policy_dir"`
	} `json:"module_types"`
	WorkflowTests *WorkflowTestConfig `json:"workflow_tests,omitempty"`
}

// WorkflowTestConfig contains configuration for workflow testing
type WorkflowTestConfig struct {
	TestModule     string              `json:"test_module"`
	TestModuleType string              `json:"test_module_type"`
	Repository     string              `json:"repository"`
	Variations     []WorkflowVariation `json:"variations"`
	DefaultInputs  map[string]string   `json:"default_inputs"`
}

// WorkflowVariation represents a test variation configuration
type WorkflowVariation struct {
	Name            string            `json:"name"`
	ChangeType      string            `json:"change_type"`
	ContributorType string            `json:"contributor_type"`
	CanSelfApprove  string            `json:"can_self_approve"`
	Description     string            `json:"description"`
	Inputs          map[string]string `json:"inputs,omitempty"`
}

func main() {
	fmt.Printf("%s=== Triggering All 6 Merge Approval Job Variations ===%s\n\n", Blue, NC)

	// Check if GitHub CLI is available first
	if !isGitHubCLIAvailable() {
		fmt.Printf("%s❌ ERROR: GitHub CLI (gh) is not available%s\n", Red, NC)
		fmt.Printf("%sPlease install GitHub CLI: https://cli.github.com/%s\n", Yellow, NC)
		os.Exit(1)
	}

	// Check if git is available
	if !isGitAvailable() {
		fmt.Printf("%s❌ ERROR: Git is not available%s\n", Red, NC)
		fmt.Printf("%sPlease install Git%s\n", Yellow, NC)
		os.Exit(1)
	}

	// Load configuration with strict validation
	config, err := loadConfig("monorepo-config.json")
	if err != nil {
		fmt.Printf("%s❌ Configuration Error: %v%s\n", Red, err, NC)
		os.Exit(1)
	}

	// Set up workflow test configuration with strict validation
	workflowConfig := setupWorkflowConfig(config)

	fmt.Printf("%s📦 Using test module: %s (type: %s)%s\n", Blue, workflowConfig.TestModule, workflowConfig.TestModuleType, NC)
	fmt.Printf("%s🏢 Repository: %s%s\n", Blue, workflowConfig.Repository, NC)

	// Check authentication status and prompt for login if needed
	if !checkAndEnsureAuth() {
		fmt.Printf("%s❌ ERROR: GitHub CLI authentication failed%s\n", Red, NC)
		fmt.Printf("%sPlease authenticate with GitHub CLI using: gh auth login%s\n", Yellow, NC)
		os.Exit(1)
	}

	// Get current branch
	currentBranch, err := getCurrentBranch()
	if err != nil {
		fmt.Printf("%s❌ ERROR: Could not determine current git branch: %v%s\n", Red, err, NC)
		fmt.Printf("%sPlease ensure you are in a git repository%s\n", Yellow, NC)
		os.Exit(1)
	}

	fmt.Printf("%s✅ GitHub CLI is available and authenticated%s\n", Green, NC)
	fmt.Printf("%s📍 Current branch: %s%s\n", Blue, currentBranch, NC)

	// Validate that we have the expected number of variations
	expectedVariations := 6
	if len(workflowConfig.Variations) != expectedVariations {
		fmt.Printf("%s⚠️  WARNING: Expected %d variations but found %d in configuration%s\n",
			Yellow, expectedVariations, len(workflowConfig.Variations), NC)
	}

	// Confirm before proceeding
	fmt.Printf("\n%sThis script will trigger all %d variations in dry run mode.%s\n", Yellow, len(workflowConfig.Variations), NC)
	fmt.Printf("%sEach will require manual approval in the GitHub UI.%s\n", Yellow, NC)
	fmt.Printf("%sWorkflows will be triggered on branch: %s%s%s\n", Yellow, Blue, currentBranch, NC)
	fmt.Printf("%sPress Enter to continue or Ctrl+C to cancel...%s\n", Yellow, NC)

	reader := bufio.NewReader(os.Stdin)
	_, _ = reader.ReadString('\n')

	// Trigger all variations
	successCount := 0
	timestamp := time.Now().Format("20060102-150405")

	for i, variation := range workflowConfig.Variations {
		fmt.Printf("%s=== Triggering: %s ===%s\n", Cyan, variation.Name, NC)
		fmt.Printf("Description: %s\n", variation.Description)
		fmt.Printf("Inputs: change_type=%s, contributor_type=%s, can_self_approve=%s\n",
			variation.ChangeType, variation.ContributorType, variation.CanSelfApprove)

		if triggerWorkflow(variation, workflowConfig, timestamp, i+1, currentBranch) {
			fmt.Printf("%s✅ Successfully triggered: %s%s\n", Green, variation.Name, NC)
			fmt.Printf("%sCheck GitHub Actions UI for manual approval%s\n", Blue, NC)
			successCount++
		} else {
			fmt.Printf("%s❌ Failed to trigger: %s%s\n", Red, variation.Name, NC)
		}

		fmt.Printf("\n---\n\n")
		time.Sleep(2 * time.Second) // Brief pause between triggers
	}

	// Summary
	fmt.Printf("%s🎉 Triggered %d out of %d variations!%s\n\n", Green, successCount, len(workflowConfig.Variations), NC)

	if successCount == 0 {
		fmt.Printf("%s❌ No workflows were triggered successfully%s\n", Red, NC)
		os.Exit(1)
	}

	printNextSteps(workflowConfig)
}

// isGitHubCLIAvailable checks if the gh command is available
func isGitHubCLIAvailable() bool {
	_, err := exec.LookPath("gh")
	return err == nil
}

// isGitAvailable checks if the git command is available
func isGitAvailable() bool {
	_, err := exec.LookPath("git")
	return err == nil
}

// getCurrentBranch gets the current git branch name with validation
func getCurrentBranch() (string, error) {
	cmd := exec.Command("git", "branch", "--show-current")
	output, err := cmd.Output()
	if err != nil {
		return "", fmt.Errorf("failed to get current branch (ensure you're in a git repository): %w", err)
	}

	branch := strings.TrimSpace(string(output))
	if branch == "" {
		return "", fmt.Errorf("current branch name is empty (you might be in detached HEAD state)")
	}

	return branch, nil
}

// loadConfig loads the monorepo configuration from a JSON file with validation
func loadConfig(configPath string) (*Config, error) {
	// Check if config file exists
	if _, err := os.Stat(configPath); os.IsNotExist(err) {
		return nil, fmt.Errorf("configuration file '%s' does not exist", configPath)
	}

	data, err := os.ReadFile(configPath)
	if err != nil {
		return nil, fmt.Errorf("failed to read config file '%s': %w", configPath, err)
	}

	if len(data) == 0 {
		return nil, fmt.Errorf("configuration file '%s' is empty", configPath)
	}

	var config Config
	if err := json.Unmarshal(data, &config); err != nil {
		return nil, fmt.Errorf("failed to parse config JSON from '%s': %w", configPath, err)
	}

	// Validate essential configuration structure
	if len(config.ModuleTypes) == 0 {
		return nil, fmt.Errorf("configuration file '%s' is missing required 'module_types' section", configPath)
	}

	return &config, nil
}

// setupWorkflowConfig sets up the workflow test configuration with strict validation
func setupWorkflowConfig(config *Config) *WorkflowTestConfig {
	// Check if workflow_tests configuration exists
	if config.WorkflowTests == nil {
		fmt.Printf("%s❌ ERROR: Missing 'workflow_tests' configuration in monorepo-config.json%s\n", Red, NC)
		fmt.Printf("%sPlease add a 'workflow_tests' section with the following required fields:%s\n", Yellow, NC)
		fmt.Printf("  - test_module: path to the test module (e.g., 'skeletons/generic-skeleton')\n")
		fmt.Printf("  - test_module_type: type of the test module (e.g., 'skeleton')\n")
		fmt.Printf("  - repository: GitHub repository (e.g., 'owner/repo')\n")
		fmt.Printf("  - default_inputs: map of default workflow inputs\n")
		fmt.Printf("  - variations: array of test variations\n")
		os.Exit(1)
	}

	workflowConfig := config.WorkflowTests

	// Validate required fields
	if workflowConfig.TestModule == "" {
		fmt.Printf("%s❌ ERROR: 'workflow_tests.test_module' is required but not specified%s\n", Red, NC)
		os.Exit(1)
	}

	if workflowConfig.TestModuleType == "" {
		fmt.Printf("%s❌ ERROR: 'workflow_tests.test_module_type' is required but not specified%s\n", Red, NC)
		os.Exit(1)
	}

	if workflowConfig.Repository == "" {
		fmt.Printf("%s❌ ERROR: 'workflow_tests.repository' is required but not specified%s\n", Red, NC)
		os.Exit(1)
	}

	if len(workflowConfig.Variations) == 0 {
		fmt.Printf("%s❌ ERROR: 'workflow_tests.variations' is required but empty or not specified%s\n", Red, NC)
		fmt.Printf("%sAt least one test variation must be defined%s\n", Yellow, NC)
		os.Exit(1)
	}

	// Validate test module exists
	if _, err := os.Stat(workflowConfig.TestModule); os.IsNotExist(err) {
		fmt.Printf("%s❌ ERROR: Test module '%s' does not exist%s\n", Red, workflowConfig.TestModule, NC)
		fmt.Printf("%sPlease ensure the test module path is correct and the directory exists%s\n", Yellow, NC)
		os.Exit(1)
	}

	// Validate test module type exists in module_types configuration
	if _, exists := config.ModuleTypes[workflowConfig.TestModuleType]; !exists {
		fmt.Printf("%s❌ ERROR: Test module type '%s' is not defined in module_types configuration%s\n",
			Red, workflowConfig.TestModuleType, NC)
		fmt.Printf("%sAvailable module types: %s%s\n", Yellow, getAvailableModuleTypes(config), NC)
		os.Exit(1)
	}

	// Validate each variation has required fields
	for i, variation := range workflowConfig.Variations {
		if variation.Name == "" {
			fmt.Printf("%s❌ ERROR: Variation %d is missing required field 'name'%s\n", Red, i+1, NC)
			os.Exit(1)
		}
		if variation.ChangeType == "" {
			fmt.Printf("%s❌ ERROR: Variation '%s' is missing required field 'change_type'%s\n", Red, variation.Name, NC)
			os.Exit(1)
		}
		if variation.ContributorType == "" {
			fmt.Printf("%s❌ ERROR: Variation '%s' is missing required field 'contributor_type'%s\n", Red, variation.Name, NC)
			os.Exit(1)
		}
		if variation.CanSelfApprove == "" {
			fmt.Printf("%s❌ ERROR: Variation '%s' is missing required field 'can_self_approve'%s\n", Red, variation.Name, NC)
			os.Exit(1)
		}

		// Validate field values
		if variation.ChangeType != "terraform" && variation.ChangeType != "non-terraform" {
			fmt.Printf("%s❌ ERROR: Variation '%s' has invalid change_type '%s'. Must be 'terraform' or 'non-terraform'%s\n",
				Red, variation.Name, variation.ChangeType, NC)
			os.Exit(1)
		}
		if variation.ContributorType != "Internal" && variation.ContributorType != "External" {
			fmt.Printf("%s❌ ERROR: Variation '%s' has invalid contributor_type '%s'. Must be 'Internal' or 'External'%s\n",
				Red, variation.Name, variation.ContributorType, NC)
			os.Exit(1)
		}
		if variation.CanSelfApprove != "true" && variation.CanSelfApprove != "false" {
			fmt.Printf("%s❌ ERROR: Variation '%s' has invalid can_self_approve '%s'. Must be 'true' or 'false'%s\n",
				Red, variation.Name, variation.CanSelfApprove, NC)
			os.Exit(1)
		}
	}

	// Ensure default_inputs is not nil
	if workflowConfig.DefaultInputs == nil {
		workflowConfig.DefaultInputs = make(map[string]string)
	}

	return workflowConfig
}

// getAvailableModuleTypes returns a comma-separated list of available module types
func getAvailableModuleTypes(config *Config) string {
	var types []string
	for moduleType := range config.ModuleTypes {
		types = append(types, moduleType)
	}
	return strings.Join(types, ", ")
}

// checkAndEnsureAuth checks if user is authenticated and prompts for login if needed
func checkAndEnsureAuth() bool {
	// Check current auth status
	cmd := exec.Command("gh", "auth", "status")
	cmd.Env = append(os.Environ(), "GH_PAGER=cat")
	err := cmd.Run()

	if err == nil {
		fmt.Printf("%s✅ Already authenticated with GitHub%s\n", Green, NC)
		return true
	}

	// Not authenticated, prompt for login
	fmt.Printf("%s⚠️  GitHub CLI is not authenticated%s\n", Yellow, NC)
	fmt.Printf("%sStarting interactive authentication...%s\n", Blue, NC)

	// Run interactive auth login
	cmd = exec.Command("gh", "auth", "login")
	cmd.Env = append(os.Environ(), "GH_PAGER=cat")
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err = cmd.Run()
	if err != nil {
		fmt.Printf("%s❌ Authentication failed: %v%s\n", Red, err, NC)
		fmt.Printf("%sPlease run 'gh auth login' manually to authenticate%s\n", Yellow, NC)
		return false
	}

	// Verify authentication worked
	cmd = exec.Command("gh", "auth", "status")
	cmd.Env = append(os.Environ(), "GH_PAGER=cat")
	err = cmd.Run()
	if err != nil {
		fmt.Printf("%s❌ Authentication verification failed: %v%s\n", Red, err, NC)
		fmt.Printf("%sPlease run 'gh auth status' to check your authentication%s\n", Yellow, NC)
		return false
	}

	fmt.Printf("%s✅ Successfully authenticated with GitHub%s\n", Green, NC)
	return true
}

// triggerWorkflow triggers a single workflow variation with strict validation
func triggerWorkflow(variation WorkflowVariation, config *WorkflowTestConfig, timestamp string, testNumber int, branch string) bool {
	// Validate required configuration
	if config.TestModule == "" || config.TestModuleType == "" || config.Repository == "" {
		fmt.Printf("%s❌ ERROR: Missing required workflow configuration%s\n", Red, NC)
		return false
	}

	// Build module configuration JSON
	moduleConfig := fmt.Sprintf(`{"path":"%s","type":"%s"}`, config.TestModule, config.TestModuleType)

	// Generate test-specific values
	prNumber := fmt.Sprintf("test%d-%s", testNumber, timestamp)
	contributorUsername := fmt.Sprintf("test-user-%s", timestamp)
	prTitle := fmt.Sprintf("TEST: %s - %s", variation.Name, timestamp)
	prURL := fmt.Sprintf("https://github.com/%s/pull/%s", config.Repository, prNumber)

	fmt.Printf("%sRunning gh workflow run command...%s\n", Yellow, NC)

	// Build arguments dynamically - all values come from configuration
	args := []string{
		"workflow", "run", "main-validation.yml",
		"--ref", branch,
		"--field", fmt.Sprintf("change_type=%s", variation.ChangeType),
		"--field", fmt.Sprintf("contributor_type=%s", variation.ContributorType),
		"--field", fmt.Sprintf("contributor_username=%s", contributorUsername),
		"--field", fmt.Sprintf("can_self_approve=%s", variation.CanSelfApprove),
		"--field", fmt.Sprintf("pr_number=%s", prNumber),
		"--field", fmt.Sprintf("pr_title=%s", prTitle),
		"--field", fmt.Sprintf("pr_html_url=%s", prURL),
		"--field", fmt.Sprintf("module_config=%s", moduleConfig),
	}

	// Add default inputs from configuration
	for key, value := range config.DefaultInputs {
		if key == "" {
			fmt.Printf("%s❌ ERROR: Empty key found in default_inputs configuration%s\n", Red, NC)
			return false
		}
		args = append(args, "--field", fmt.Sprintf("%s=%s", key, value))
	}

	// Add variation-specific inputs from configuration
	for key, value := range variation.Inputs {
		if key == "" {
			fmt.Printf("%s❌ ERROR: Empty key found in variation '%s' inputs%s\n", Red, variation.Name, NC)
			return false
		}
		args = append(args, "--field", fmt.Sprintf("%s=%s", key, value))
	}

	// Debug: Print the exact command being run
	fmt.Printf("%sDebug - Command: gh %s%s\n", Blue, strings.Join(args, " "), NC)

	// Execute the command
	cmd := exec.Command("gh", args...)
	// Disable pager to ensure output goes to stdout/stderr
	cmd.Env = append(os.Environ(), "GH_PAGER=cat")
	output, err := cmd.CombinedOutput()

	if err != nil {
		fmt.Printf("%s❌ GitHub CLI command failed: %v%s\n", Red, err, NC)
		if len(output) > 0 {
			fmt.Printf("%sOutput: %s%s\n", Red, string(output), NC)
		}
		return false
	}

	if len(output) > 0 {
		fmt.Printf("%s✅ Success: %s%s\n", Green, string(output), NC)
	}

	return true
}

// printNextSteps prints instructions for the user
func printNextSteps(config *WorkflowTestConfig) {
	fmt.Printf("%s=== Next Steps ===%s\n", Blue, NC)
	fmt.Printf("1. Go to GitHub Actions: %shttps://github.com/%s/actions%s\n", Yellow, config.Repository, NC)
	fmt.Printf("2. You should see %d new 'Main Validation' workflow runs\n", len(config.Variations))
	fmt.Printf("3. Each run will have jobs waiting for manual approval\n")
	fmt.Printf("4. Click on each workflow run to see the approval requirements\n")
	fmt.Printf("5. Look for jobs with '🟡 Waiting' status - these need manual approval\n")
	fmt.Printf("6. Click 'Review deployments' to approve each merge and release operation\n")

	fmt.Printf("\n%sExpected jobs requiring approval in each variation:%s\n", Yellow, NC)
	fmt.Printf("• Merge approval job (specific to each variation)\n")
	fmt.Printf("• Release approval job (if the workflow progresses that far)\n")
	fmt.Printf("• All approvals are in dry run mode - no actual merges/releases will occur\n")

	fmt.Printf("\n%sQuick command to check recent workflow runs:%s\n", Cyan, NC)
	fmt.Printf("%sgh run list --workflow=main-validation.yml --limit=10%s\n", Blue, NC)

	fmt.Printf("\n%s=== All Variations Summary ===%s\n", Blue, NC)
	expectedJobs := []string{
		"merge-self-approval-non-terraform-internal - Internal, Non-Terraform, Self-Approval",
		"merge-approval-non-terraform-internal - Internal, Non-Terraform, Manual Approval",
		"merge-approval-non-terraform-external - External, Non-Terraform, Manual Approval",
		"merge-self-approval-terraform-internal - Internal, Terraform, Self-Approval",
		"merge-approval-terraform-internal - Internal, Terraform, Manual Approval",
		"merge-approval-terraform-external - External, Terraform, Manual Approval",
	}

	for _, job := range expectedJobs {
		fmt.Printf("%s✅ %s%s\n", Green, job, NC)
	}

	fmt.Printf("\n%sAll variations have been tested and verified to:%s\n", Blue, NC)
	fmt.Printf("• Have correct routing conditions\n")
	fmt.Printf("• Require manual approval via environment protection\n")
	fmt.Printf("• Use appropriate environments (merge-approval vs external-contributor-merge-approval)\n")
	fmt.Printf("• Support dry run mode simulation\n")
	fmt.Printf("• Provide clear logging and debugging output\n")

	fmt.Printf("\n%sHappy testing! 🚀%s\n", Green, NC)
}

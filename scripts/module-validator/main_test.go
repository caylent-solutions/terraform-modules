package main

import (
	"io/ioutil"
	"os"
	"testing"
)

func TestLoadConfig(t *testing.T) {
	// Create a temporary config file
	content := `{
		"module_types": {
			"service": {
				"policy_dir": "policies/service"
			}
		},
		"scripts": {
			"terraform_file_collector": "scripts/terraform-file-collector/main.go",
			"temp_file_pattern": "terraform-files-*.json"
		}
	}`

	tmpFile, err := ioutil.TempFile("", "config-*.json")
	if err != nil {
		t.Fatalf("Failed to create temp file: %v", err)
	}
	defer os.Remove(tmpFile.Name())

	if _, err := tmpFile.Write([]byte(content)); err != nil {
		t.Fatalf("Failed to write to temp file: %v", err)
	}
	if err := tmpFile.Close(); err != nil {
		t.Fatalf("Failed to close temp file: %v", err)
	}

	// Test loading the config
	config, err := loadConfig(tmpFile.Name())
	if err != nil {
		t.Fatalf("loadConfig() error = %v", err)
	}

	// Verify the config was loaded correctly
	moduleTypes, ok := config["module_types"].(map[string]interface{})
	if !ok {
		t.Fatalf("Expected module_types to be a map")
	}

	serviceType, ok := moduleTypes["service"].(map[string]interface{})
	if !ok {
		t.Fatalf("Expected service to be a map")
	}

	policyDir, ok := serviceType["policy_dir"].(string)
	if !ok {
		t.Fatalf("Expected policy_dir to be a string")
	}

	if policyDir != "policies/service" {
		t.Fatalf("Expected policy_dir to be 'policies/service', got '%s'", policyDir)
	}

	scripts, ok := config["scripts"].(map[string]interface{})
	if !ok {
		t.Fatalf("Expected scripts to be a map")
	}

	tfCollector, ok := scripts["terraform_file_collector"].(string)
	if !ok {
		t.Fatalf("Expected terraform_file_collector to be a string")
	}

	if tfCollector != "scripts/terraform-file-collector/main.go" {
		t.Fatalf("Expected terraform_file_collector to be 'scripts/terraform-file-collector/main.go', got '%s'", tfCollector)
	}
}

func TestGetPackageName(t *testing.T) {
	// Create a temporary Rego file
	content := `# This is a comment
package terraform.module.service

import data.common

# Some rules
violation[result] {
    # Rule implementation
}`

	tmpFile, err := ioutil.TempFile("", "policy-*.rego")
	if err != nil {
		t.Fatalf("Failed to create temp file: %v", err)
	}
	defer os.Remove(tmpFile.Name())

	if _, err := tmpFile.Write([]byte(content)); err != nil {
		t.Fatalf("Failed to write to temp file: %v", err)
	}
	if err := tmpFile.Close(); err != nil {
		t.Fatalf("Failed to close temp file: %v", err)
	}

	// Test extracting the package name
	packageName := getPackageName(tmpFile.Name())
	expected := "terraform.module.service"

	if packageName != expected {
		t.Errorf("getPackageName() = %s, want %s", packageName, expected)
	}

	// Test with a file that doesn't have a package declaration
	content = `# This is a comment
import data.common

# Some rules
violation[result] {
    # Rule implementation
}`

	tmpFile2, err := ioutil.TempFile("", "policy-no-package-*.rego")
	if err != nil {
		t.Fatalf("Failed to create temp file: %v", err)
	}
	defer os.Remove(tmpFile2.Name())

	if _, err := tmpFile2.Write([]byte(content)); err != nil {
		t.Fatalf("Failed to write to temp file: %v", err)
	}
	if err := tmpFile2.Close(); err != nil {
		t.Fatalf("Failed to close temp file: %v", err)
	}

	// Test extracting the package name from a file without a package declaration
	packageName = getPackageName(tmpFile2.Name())
	if packageName != "" {
		t.Errorf("getPackageName() = %s, want empty string", packageName)
	}

	// Test with a non-existent file
	packageName = getPackageName("non-existent-file.rego")
	if packageName != "" {
		t.Errorf("getPackageName() for non-existent file = %s, want empty string", packageName)
	}
}

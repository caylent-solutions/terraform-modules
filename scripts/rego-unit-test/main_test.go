package main

import (
	"io/ioutil"
	"os"
	"path/filepath"
	"testing"
)

func TestReadConfig(t *testing.T) {
	// Create a temporary config file
	tmpDir, err := ioutil.TempDir("", "test")
	if err != nil {
		t.Fatalf("Failed to create temp dir: %v", err)
	}
	defer os.RemoveAll(tmpDir)

	configPath := filepath.Join(tmpDir, "config.json")
	configData := `{
		"rego_tests": [
			"tests/opa/unit/global",
			"tests/opa/unit/terraform/module"
		]
	}`

	err = ioutil.WriteFile(configPath, []byte(configData), 0644)
	if err != nil {
		t.Fatalf("Failed to write config file: %v", err)
	}

	// Test reading the config
	config, err := readConfig(configPath)
	if err != nil {
		t.Fatalf("Failed to read config: %v", err)
	}

	// Verify the config
	if len(config.RegoTests) != 2 {
		t.Errorf("Expected 2 test paths, got %d", len(config.RegoTests))
	}
	if config.RegoTests[0] != "tests/opa/unit/global" {
		t.Errorf("Expected first test path to be 'tests/opa/unit/global', got '%s'", config.RegoTests[0])
	}
	if config.RegoTests[1] != "tests/opa/unit/terraform/module" {
		t.Errorf("Expected second test path to be 'tests/opa/unit/terraform/module', got '%s'", config.RegoTests[1])
	}
}

func TestGetFileExtension(t *testing.T) {
	if ext := getFileExtension(true); ext != "json" {
		t.Errorf("Expected 'json', got '%s'", ext)
	}
	if ext := getFileExtension(false); ext != "txt" {
		t.Errorf("Expected 'txt', got '%s'", ext)
	}
}

package main

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"reflect"
	"testing"
)

func TestLoadConfig(t *testing.T) {
	// Create a temporary config file
	content := `{
		"module_types": {
			"service": {
				"path_patterns": ["modules/service/*"]
			}
		},
		"test_changed_files": [
			"modules/service/example/main.tf",
			"README.md"
		]
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
	
	pathPatterns, ok := serviceType["path_patterns"].([]interface{})
	if !ok {
		t.Fatalf("Expected path_patterns to be an array")
	}
	
	if len(pathPatterns) != 1 || pathPatterns[0].(string) != "modules/service/*" {
		t.Fatalf("Expected path_patterns to contain 'modules/service/*'")
	}
	
	// Check test_changed_files
	changedFiles, ok := config["test_changed_files"].([]interface{})
	if !ok {
		t.Fatalf("Expected test_changed_files to be an array")
	}
	
	if len(changedFiles) != 2 {
		t.Fatalf("Expected test_changed_files to have 2 entries, got %d", len(changedFiles))
	}
}

func TestGetChangedFiles(t *testing.T) {
	// Test with files in config
	config := map[string]interface{}{
		"test_changed_files": []interface{}{
			"modules/service/example/main.tf",
			"modules/data/other/file.tf",
		},
	}
	
	expected := []string{
		"modules/service/example/main.tf",
		"modules/data/other/file.tf",
	}
	
	files := getChangedFiles("feature-branch", "main", config)
	if !reflect.DeepEqual(files, expected) {
		t.Errorf("getChangedFiles() = %v, want %v", files, expected)
	}
	
	// Test with no files in config (should try to use git, but we'll just check it doesn't crash)
	config = map[string]interface{}{}
	files = getChangedFiles("feature-branch", "main", config)
	// We don't assert anything specific here since git might not be available in the test environment
}

func TestPolicyInputMarshaling(t *testing.T) {
	// Test that PolicyInput can be properly marshaled to JSON
	input := PolicyInput{
		ChangedFiles: []string{"file1.tf", "file2.tf"},
		Config: map[string]interface{}{
			"key1": "value1",
			"key2": 42,
		},
	}
	
	data, err := json.Marshal(input)
	if err != nil {
		t.Fatalf("Failed to marshal PolicyInput: %v", err)
	}
	
	// Unmarshal back to verify
	var decoded PolicyInput
	if err := json.Unmarshal(data, &decoded); err != nil {
		t.Fatalf("Failed to unmarshal PolicyInput: %v", err)
	}
	
	// Check that the fields were preserved
	if !reflect.DeepEqual(input.ChangedFiles, decoded.ChangedFiles) {
		t.Errorf("ChangedFiles not preserved in JSON marshaling")
	}
	
	// Check that Config was preserved (comparing as JSON strings since map ordering might differ)
	inputConfigJSON, _ := json.Marshal(input.Config)
	decodedConfigJSON, _ := json.Marshal(decoded.Config)
	if string(inputConfigJSON) != string(decodedConfigJSON) {
		t.Errorf("Config not preserved in JSON marshaling")
	}
}
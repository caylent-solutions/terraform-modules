package main

import (
	"io/ioutil"
	"os"
	"reflect"
	"sort"
	"testing"
)

func TestLoadConfig(t *testing.T) {
	// Create a temporary config file
	content := `{
		"module_types": {
			"service": {
				"path_patterns": ["modules/service/*"]
			}
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

	pathPatterns, ok := serviceType["path_patterns"].([]interface{})
	if !ok {
		t.Fatalf("Expected path_patterns to be an array")
	}

	if len(pathPatterns) != 1 || pathPatterns[0].(string) != "modules/service/*" {
		t.Fatalf("Expected path_patterns to contain 'modules/service/*'")
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

	files := getChangedFiles(config)
	if !reflect.DeepEqual(files, expected) {
		t.Errorf("getChangedFiles() = %v, want %v", files, expected)
	}

	// Test with empty files array in config
	config = map[string]interface{}{
		"test_changed_files": []interface{}{},
	}
	files = getChangedFiles(config)
	if len(files) != 0 {
		t.Errorf("getChangedFiles() with empty array should return empty slice")
	}
}

func TestMatchesPattern(t *testing.T) {
	tests := []struct {
		name        string
		filePath    string
		pattern     string
		wantMatched bool
		wantPath    string
	}{
		{
			name:        "Exact match",
			filePath:    "modules/service/example/main.tf",
			pattern:     "modules/service/example",
			wantMatched: true,
			wantPath:    "modules/service/example",
		},
		{
			name:        "Wildcard match",
			filePath:    "modules/service/example/main.tf",
			pattern:     "modules/service/*",
			wantMatched: true,
			wantPath:    "modules/service/example",
		},
		{
			name:        "No match",
			filePath:    "modules/data/example/main.tf",
			pattern:     "modules/service/*",
			wantMatched: false,
			wantPath:    "",
		},
		{
			name:        "File path too short",
			filePath:    "modules/service",
			pattern:     "modules/service/example",
			wantMatched: false,
			wantPath:    "",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			gotMatched, gotPath := matchesPattern(tt.filePath, tt.pattern)
			if gotMatched != tt.wantMatched {
				t.Errorf("matchesPattern() matched = %v, want %v", gotMatched, tt.wantMatched)
			}
			if gotPath != tt.wantPath {
				t.Errorf("matchesPattern() path = %v, want %v", gotPath, tt.wantPath)
			}
		})
	}
}

func TestDetectModuleChanges(t *testing.T) {
	config := map[string]interface{}{
		"module_types": map[string]interface{}{
			"service": map[string]interface{}{
				"path_patterns": []interface{}{
					"modules/service/*",
				},
			},
			"data": map[string]interface{}{
				"path_patterns": []interface{}{
					"modules/data/*",
				},
			},
		},
	}

	tests := []struct {
		name         string
		changedFiles []string
		wantPaths    []string
		wantTypes    []string
	}{
		{
			name:         "Service module change",
			changedFiles: []string{"modules/service/example/main.tf"},
			wantPaths:    []string{"modules/service/example"},
			wantTypes:    []string{"service"},
		},
		{
			name:         "Data module change",
			changedFiles: []string{"modules/data/example/main.tf"},
			wantPaths:    []string{"modules/data/example"},
			wantTypes:    []string{"data"},
		},
		{
			name:         "Multiple files with service module change",
			changedFiles: []string{"README.md", "modules/service/example/main.tf"},
			wantPaths:    []string{"modules/service/example"},
			wantTypes:    []string{"service"},
		},
		{
			name:         "Multiple module changes",
			changedFiles: []string{"modules/service/example/main.tf", "modules/data/example/main.tf"},
			wantPaths:    []string{"modules/service/example", "modules/data/example"},
			wantTypes:    []string{"service", "data"},
		},
		{
			name:         "No module changes",
			changedFiles: []string{"README.md", "scripts/test.sh"},
			wantPaths:    []string{},
			wantTypes:    []string{},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			gotPaths, gotTypes := detectModuleChanges(tt.changedFiles, config)

			// Sort the results for consistent comparison
			sort.Strings(gotPaths)
			sort.Strings(gotTypes)
			expectedPaths := make([]string, len(tt.wantPaths))
			expectedTypes := make([]string, len(tt.wantTypes))
			copy(expectedPaths, tt.wantPaths)
			copy(expectedTypes, tt.wantTypes)
			sort.Strings(expectedPaths)
			sort.Strings(expectedTypes)

			if !reflect.DeepEqual(gotPaths, expectedPaths) {
				t.Errorf("detectModuleChanges() paths = %v, want %v", gotPaths, expectedPaths)
			}
			if !reflect.DeepEqual(gotTypes, expectedTypes) {
				t.Errorf("detectModuleChanges() types = %v, want %v", gotTypes, expectedTypes)
			}
		})
	}
}

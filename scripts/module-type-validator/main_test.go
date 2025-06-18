package main

import (
	"io/ioutil"
	"os"
	"path/filepath"
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

func TestGlobToRegex(t *testing.T) {
	tests := []struct {
		name     string
		pattern  string
		expected string
	}{
		{
			name:     "Simple pattern",
			pattern:  "modules/service",
			expected: ".*modules/service.*",
		},
		{
			name:     "Pattern with wildcard",
			pattern:  "modules/*/service",
			expected: ".*modules/.*/service.*",
		},
		{
			name:     "Pattern with dot",
			pattern:  "modules/service.v1",
			expected: ".*modules/service\\.v1.*",
		},
		{
			name:     "Pattern with question mark",
			pattern:  "modules/service?",
			expected: ".*modules/service..*",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := globToRegex(tt.pattern)
			if result != tt.expected {
				t.Errorf("globToRegex(%s) = %s, want %s", tt.pattern, result, tt.expected)
			}
		})
	}
}

func TestDetectModuleType(t *testing.T) {
	// Create a temporary directory structure
	tmpDir, err := ioutil.TempDir("", "module-test")
	if err != nil {
		t.Fatalf("Failed to create temp dir: %v", err)
	}
	defer os.RemoveAll(tmpDir)

	// Create a service module directory
	serviceDir := filepath.Join(tmpDir, "modules", "service", "example")
	if err := os.MkdirAll(serviceDir, 0755); err != nil {
		t.Fatalf("Failed to create service dir: %v", err)
	}

	// Create a data module directory
	dataDir := filepath.Join(tmpDir, "modules", "data", "example")
	if err := os.MkdirAll(dataDir, 0755); err != nil {
		t.Fatalf("Failed to create data dir: %v", err)
	}

	// Create config
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

	// Test service module detection
	moduleType := detectModuleType(serviceDir, config)
	if moduleType != "service" {
		t.Errorf("detectModuleType() for service dir = %s, want %s", moduleType, "service")
	}

	// Test data module detection
	moduleType = detectModuleType(dataDir, config)
	if moduleType != "data" {
		t.Errorf("detectModuleType() for data dir = %s, want %s", moduleType, "data")
	}

	// Test unknown module detection
	unknownDir := filepath.Join(tmpDir, "modules", "unknown", "example")
	if err := os.MkdirAll(unknownDir, 0755); err != nil {
		t.Fatalf("Failed to create unknown dir: %v", err)
	}

	moduleType = detectModuleType(unknownDir, config)
	if moduleType != "unknown" {
		t.Errorf("detectModuleType() for unknown dir = %s, want %s", moduleType, "unknown")
	}
}

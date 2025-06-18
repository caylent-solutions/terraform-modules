package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

// ModuleType represents the type of Terraform module
type ModuleType string

func main() {
	modulePath := flag.String("module-path", "", "Path to the Terraform module")
	configPath := flag.String("config", "", "Path to the monorepo configuration file")
	flag.Parse()

	if *modulePath == "" {
		fmt.Println("Error: Module path is required")
		os.Exit(1)
	}

	if *configPath == "" {
		fmt.Println("Error: Config path is required")
		os.Exit(1)
	}

	// Load configuration
	config, err := loadConfig(*configPath)
	if err != nil {
		fmt.Printf("Error loading configuration: %v\n", err)
		os.Exit(1)
	}

	moduleType := detectModuleType(*modulePath, config)
	fmt.Printf("MODULE_TYPE=%s\n", moduleType)

	// Output for GitHub Actions
	if os.Getenv("GITHUB_ACTIONS") == "true" {
		fmt.Printf("::set-output name=module_type::%s\n", moduleType)
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

// detectModuleType determines the type of Terraform module based on its path
func detectModuleType(modulePath string, config map[string]interface{}) string {
	// Convert to absolute path and normalize
	absPath, err := filepath.Abs(modulePath)
	if err != nil {
		fmt.Printf("Error getting absolute path: %v\n", err)
		return "unknown"
	}

	// Get module types from config
	moduleTypes, ok := config["module_types"].(map[string]interface{})
	if !ok {
		fmt.Println("Error: module_types not found in config")
		return "unknown"
	}

	// Check each module type's path patterns
	for typeName, typeConfig := range moduleTypes {
		typeConfigMap, ok := typeConfig.(map[string]interface{})
		if !ok {
			continue
		}

		pathPatterns, ok := typeConfigMap["path_patterns"].([]interface{})
		if !ok {
			continue
		}

		for _, pattern := range pathPatterns {
			patternStr, ok := pattern.(string)
			if !ok {
				continue
			}

			// Convert glob pattern to regex
			regexPattern := globToRegex(patternStr)
			matched, err := regexp.MatchString(regexPattern, absPath)
			if err == nil && matched {
				return typeName
			}
		}
	}

	return "unknown"
}

// globToRegex converts a glob pattern to a regex pattern
func globToRegex(pattern string) string {
	// Replace common glob characters with regex equivalents
	pattern = strings.ReplaceAll(pattern, ".", "\\.")
	pattern = strings.ReplaceAll(pattern, "*", ".*")
	pattern = strings.ReplaceAll(pattern, "?", ".")

	// Ensure the pattern matches the full path
	return ".*" + pattern + ".*"
}

package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	configPath := flag.String("config", "", "Path to the monorepo configuration file")
	flag.Parse()

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

	// Get changed files
	changedFiles := getChangedFiles(config)
	if len(changedFiles) == 0 {
		fmt.Println("No changed files detected")
		fmt.Println("IS_MODULE=false")
		if os.Getenv("GITHUB_ACTIONS") == "true" {
			fmt.Println("::set-output name=is_module::false")
		}
		os.Exit(0)
	}

	// Check if changes are in a module
	modulePath, moduleType := detectModuleChanges(changedFiles, config)
	
	if modulePath != "" {
		fmt.Printf("MODULE_PATH=%s\n", modulePath)
		fmt.Printf("MODULE_TYPE=%s\n", moduleType)
		fmt.Println("IS_MODULE=true")
		
		if os.Getenv("GITHUB_ACTIONS") == "true" {
			fmt.Printf("::set-output name=module_path::%s\n", modulePath)
			fmt.Printf("::set-output name=module_type::%s\n", moduleType)
			fmt.Println("::set-output name=is_module::true")
		}
	} else {
		fmt.Println("No module changes detected")
		fmt.Println("IS_MODULE=false")
		if os.Getenv("GITHUB_ACTIONS") == "true" {
			fmt.Println("::set-output name=is_module::false")
		}
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

// getChangedFiles gets the list of changed files from the configuration
func getChangedFiles(config map[string]interface{}) []string {
	// For testing, use files from config if provided
	if files, ok := config["test_changed_files"].([]interface{}); ok && len(files) > 0 {
		changedFiles := make([]string, len(files))
		for i, file := range files {
			changedFiles[i] = file.(string)
		}
		return changedFiles
	}
	return []string{}
}

// detectModuleChanges determines if changes are in a module and returns the module path and type
func detectModuleChanges(changedFiles []string, config map[string]interface{}) (string, string) {
	// Get module types from config
	moduleTypes, ok := config["module_types"].(map[string]interface{})
	if !ok {
		fmt.Println("Error: module_types not found in config")
		return "", ""
	}
	
	// Check each file against module path patterns
	for _, file := range changedFiles {
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
				
				// Check if file matches the pattern
				matched, modulePath := matchesPattern(file, patternStr)
				if matched {
					return modulePath, typeName
				}
			}
		}
	}
	
	return "", ""
}

// matchesPattern checks if a file path matches a pattern and returns the module path
func matchesPattern(filePath, pattern string) (bool, string) {
	// Convert glob pattern to path components
	patternParts := strings.Split(pattern, "/")
	fileParts := strings.Split(filePath, "/")
	
	// Check if file path has enough components
	if len(fileParts) < len(patternParts) {
		return false, ""
	}
	
	// Check each pattern component
	modulePath := ""
	for i, part := range patternParts {
		if part == "*" {
			// Wildcard matches any component
			modulePath += "/" + fileParts[i]
		} else if fileParts[i] != part {
			// Component doesn't match
			return false, ""
		} else {
			// Component matches
			modulePath += "/" + part
		}
	}
	
	// Trim leading slash
	modulePath = strings.TrimPrefix(modulePath, "/")
	
	return true, modulePath
}
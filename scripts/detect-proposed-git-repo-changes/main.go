package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
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
		fmt.Println("Error: No changed files provided in test_changed_files")
		os.Exit(1)
	}

	// Check if changes are in modules
	modulePaths, moduleTypes := detectModuleChanges(changedFiles, config)

	// Get module roots from config
	moduleRoots, ok := config["module_roots"].([]interface{})
	if !ok {
		fmt.Println("Error: module_roots not found in config")
		os.Exit(1)
	}

	// Identify non-module files
	nonModuleFiles := []string{}
	for _, file := range changedFiles {
		isModuleFile := false
		for _, root := range moduleRoots {
			rootStr, ok := root.(string)
			if !ok {
				continue
			}
			if strings.HasPrefix(file, rootStr) {
				isModuleFile = true
				break
			}
		}
		if !isModuleFile {
			nonModuleFiles = append(nonModuleFiles, file)
		}
	}

	if len(modulePaths) > 1 {
		fmt.Println("Error: Multiple modules detected in the same PR")
		fmt.Println("Affected modules:")
		for i, path := range modulePaths {
			fmt.Printf("  - %s (type: %s)\n", path, moduleTypes[i])
		}
		fmt.Println("PRs should only modify a single module at a time")
		os.Exit(1)
	} else if len(modulePaths) == 1 && len(nonModuleFiles) > 0 {
		fmt.Println("Error: Mixed module and non-module changes detected in the same PR")
		fmt.Printf("Module: %s (type: %s)\n", modulePaths[0], moduleTypes[0])
		fmt.Println("Non-module files:")
		for _, file := range nonModuleFiles {
			fmt.Printf("  - %s\n", file)
		}
		fmt.Println("PRs should either modify exactly one module OR only non-module files, not both")
		os.Exit(1)
	} else if len(modulePaths) == 1 {
		modulePath := modulePaths[0]
		moduleType := moduleTypes[0]

		fmt.Printf("MODULE_PATH=%s\n", modulePath)
		fmt.Printf("MODULE_TYPE=%s\n", moduleType)
		fmt.Println("IS_MODULE=true")
	} else {
		fmt.Println("No module changes detected")
		fmt.Println("IS_MODULE=false")
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
	if files, ok := config["test_changed_files"].([]interface{}); ok {
		changedFiles := make([]string, len(files))
		for i, file := range files {
			changedFiles[i] = file.(string)
		}
		return changedFiles
	}

	// If test_changed_files is not provided, this is an error
	fmt.Println("Error: test_changed_files not found in config")
	os.Exit(1)
	return []string{}
}

// detectModuleChanges determines if changes are in modules and returns the module paths and types
func detectModuleChanges(changedFiles []string, config map[string]interface{}) ([]string, []string) {
	// Get provider config from config
	providerConfig, ok := config["provider"].(map[string]interface{})
	if !ok {
		fmt.Println("Error: provider not found in config")
		os.Exit(1)
	}

	// Maps to track unique modules
	modulePathMap := make(map[string]string)

	// Get sorted provider names for deterministic ordering
	providerNames := make([]string, 0, len(providerConfig))
	for providerName := range providerConfig {
		providerNames = append(providerNames, providerName)
	}
	// Sort to ensure deterministic behavior
	for i := 0; i < len(providerNames)-1; i++ {
		for j := i + 1; j < len(providerNames); j++ {
			if providerNames[i] > providerNames[j] {
				providerNames[i], providerNames[j] = providerNames[j], providerNames[i]
			}
		}
	}

	// Check each file against module path patterns from all providers
	for _, file := range changedFiles {
		// Use deterministic provider ordering and stop at first match
		for _, providerName := range providerNames {
			providerData := providerConfig[providerName]
			providerMap, ok := providerData.(map[string]interface{})
			if !ok {
				continue
			}

			moduleTypes, ok := providerMap["module_types"].(map[string]interface{})
			if !ok {
				continue
			}

			matched := false
			for typeName, typeConfig := range moduleTypes {
				if matched {
					break
				}

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
					isMatch, modulePath := matchesPattern(file, patternStr)
					if isMatch {
						modulePathMap[modulePath] = typeName
						matched = true
						break
					}
				}
			}

			if matched {
				break // Stop checking other providers for this file
			}
		}
	}

	// Convert maps to slices for return
	modulePaths := []string{}
	moduleTypesList := []string{}

	for path, typeName := range modulePathMap {
		modulePaths = append(modulePaths, path)
		moduleTypesList = append(moduleTypesList, typeName)
	}

	return modulePaths, moduleTypesList
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

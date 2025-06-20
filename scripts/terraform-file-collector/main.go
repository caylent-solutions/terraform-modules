package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
)

func main() {
	modulePath := flag.String("module-path", "", "Path to the Terraform module")
	outputPath := flag.String("output", "", "Path to output JSON file")
	configPath := flag.String("config", "", "Path to the monorepo configuration file")
	flag.Parse()

	if *modulePath == "" {
		fmt.Println("Error: Module path is required")
		os.Exit(1)
	}

	if *outputPath == "" {
		fmt.Println("Error: Output path is required")
		os.Exit(1)
	}

	if *configPath == "" {
		fmt.Println("Error: Configuration file path is required")
		os.Exit(1)
	}

	// Load configuration
	config, err := loadConfig(*configPath)
	if err != nil {
		fmt.Printf("Error loading configuration: %v\n", err)
		os.Exit(1)
	}

	// Get configuration values
	var excludedDirs []string
	var importantDirs []string
	directoryMarker := "directory" // Default value

	if scripts, ok := config["scripts"].(map[string]interface{}); ok {
		// Get excluded directories
		if dirs, ok := scripts["excluded_dirs"].([]interface{}); ok {
			for _, dir := range dirs {
				if dirStr, ok := dir.(string); ok {
					excludedDirs = append(excludedDirs, dirStr)
				}
			}
		}

		// Get important directories
		if dirs, ok := scripts["important_dirs"].([]interface{}); ok {
			for _, dir := range dirs {
				if dirStr, ok := dir.(string); ok {
					importantDirs = append(importantDirs, dirStr)
				}
			}
		}

		// Get directory marker
		if marker, ok := scripts["directory_marker"].(string); ok {
			directoryMarker = marker
		}
	}

	// Collect Terraform files
	files, err := collectTerraformFiles(*modulePath, excludedDirs, importantDirs, directoryMarker)
	if err != nil {
		fmt.Printf("Error collecting Terraform files: %v\n", err)
		os.Exit(1)
	}

	// Create output structure
	output := map[string]interface{}{
		"files": files,
	}

	// Write to output file
	outputJSON, err := json.MarshalIndent(output, "", "  ")
	if err != nil {
		fmt.Printf("Error marshaling JSON: %v\n", err)
		os.Exit(1)
	}

	err = ioutil.WriteFile(*outputPath, outputJSON, 0644)
	if err != nil {
		fmt.Printf("Error writing output file: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("Terraform files collected and written to %s\n", *outputPath)
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

// collectTerraformFiles gathers all files in the module and their contents
func collectTerraformFiles(modulePath string, excludedDirs, importantDirs []string, directoryMarker string) (map[string]string, error) {
	files := make(map[string]string)

	err := filepath.Walk(modulePath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Skip excluded directories completely
		if info.IsDir() {
			dirName := filepath.Base(path)
			for _, excludedDir := range excludedDirs {
				if dirName == excludedDir {
					fmt.Printf("Skipping excluded directory: %s\n", path)
					return filepath.SkipDir
				}
			}
		}

		// Skip directories but record their existence
		if info.IsDir() {
			// Record important directories
			dirName := filepath.Base(path)
			isImportant := false

			for _, importantDir := range importantDirs {
				if dirName == importantDir {
					isImportant = true
					break
				}
			}

			if isImportant {
				relPath, err := filepath.Rel(modulePath, path)
				if err != nil {
					return err
				}
				if relPath == "." {
					return nil // Skip the root directory
				}
				fullPath := fmt.Sprintf("%s/%s", modulePath, relPath)
				files[fullPath] = directoryMarker
			}
			return nil
		}

		// Read file content
		content, err := ioutil.ReadFile(path)
		if err != nil {
			return err
		}

		// Get relative path from module path
		relPath, err := filepath.Rel(modulePath, path)
		if err != nil {
			return err
		}

		// Store with module path prefix
		fullPath := fmt.Sprintf("%s/%s", modulePath, relPath)
		files[fullPath] = string(content)
		fmt.Printf("Collected file: %s\n", fullPath)
		return nil
	})

	return files, err
}

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
	modulePath := flag.String("module-path", "", "Path to the Terraform module")
	outputPath := flag.String("output", "", "Path to output JSON file")
	flag.Parse()

	if *modulePath == "" {
		fmt.Println("Error: Module path is required")
		os.Exit(1)
	}

	if *outputPath == "" {
		fmt.Println("Error: Output path is required")
		os.Exit(1)
	}

	// Collect Terraform files
	files, err := collectTerraformFiles(*modulePath)
	if err != nil {
		fmt.Printf("Error collecting Terraform files: %v\n", err)
		os.Exit(1)
	}

	// Create output structure
	output := map[string]interface{}{
		"terraform_files": files,
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

// collectTerraformFiles gathers all .tf files in the module and their contents
func collectTerraformFiles(modulePath string) (map[string]string, error) {
	files := make(map[string]string)

	err := filepath.Walk(modulePath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Skip directories
		if info.IsDir() {
			return nil
		}

		// Only process .tf files
		if !strings.HasSuffix(path, ".tf") {
			return nil
		}

		// Read file content
		content, err := ioutil.ReadFile(path)
		if err != nil {
			return err
		}

		// Store relative path and content
		relPath, err := filepath.Rel(modulePath, path)
		if err != nil {
			return err
		}

		files[relPath] = string(content)
		return nil
	})

	return files, err
}
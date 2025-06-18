package main

import (
	"io/ioutil"
	"os"
	"path/filepath"
	"testing"
)

func TestCollectTerraformFiles(t *testing.T) {
	// Create a temporary directory structure with Terraform files
	tmpDir, err := ioutil.TempDir("", "terraform-test")
	if err != nil {
		t.Fatalf("Failed to create temp dir: %v", err)
	}
	defer os.RemoveAll(tmpDir)

	// Create some Terraform files
	files := map[string]string{
		"main.tf":           "resource \"aws_s3_bucket\" \"example\" {\n  bucket = \"example-bucket\"\n}",
		"variables.tf":      "variable \"region\" {\n  type = string\n  default = \"us-west-2\"\n}",
		"outputs.tf":        "output \"bucket_name\" {\n  value = aws_s3_bucket.example.bucket\n}",
		"nested/backend.tf": "terraform {\n  backend \"s3\" {}\n}",
		"README.md":         "# Test Module", // Include README.md as it's now collected
	}

	for path, content := range files {
		fullPath := filepath.Join(tmpDir, path)

		// Create directory if needed
		dir := filepath.Dir(fullPath)
		if err := os.MkdirAll(dir, 0755); err != nil {
			t.Fatalf("Failed to create directory %s: %v", dir, err)
		}

		// Write file
		if err := ioutil.WriteFile(fullPath, []byte(content), 0644); err != nil {
			t.Fatalf("Failed to write file %s: %v", fullPath, err)
		}
	}

	// Test collecting Terraform files
	excludedDirs := []string{"vendor", "node_modules"}
	importantDirs := []string{"examples", "tests"}
	directoryMarker := "directory"

	collected, err := collectTerraformFiles(tmpDir, excludedDirs, importantDirs, directoryMarker)
	if err != nil {
		t.Fatalf("collectTerraformFiles() error = %v", err)
	}

	// Check that we got the expected files
	expectedFiles := len(files)
	if len(collected) != expectedFiles {
		t.Errorf("Expected %d files, got %d", expectedFiles, len(collected))
	}

	// Check file contents
	for path, expectedContent := range files {
		fullPath := filepath.Join(tmpDir, path)
		content, ok := collected[fullPath]
		if !ok {
			t.Errorf("Expected file %s not found in collected files", fullPath)
			continue
		}

		if content != expectedContent {
			t.Errorf("File %s content mismatch:\nExpected: %s\nGot: %s", fullPath, expectedContent, content)
		}
	}
}

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
		"main.tf": "resource \"aws_s3_bucket\" \"example\" {\n  bucket = \"example-bucket\"\n}",
		"variables.tf": "variable \"region\" {\n  type = string\n  default = \"us-west-2\"\n}",
		"outputs.tf": "output \"bucket_name\" {\n  value = aws_s3_bucket.example.bucket\n}",
		"nested/backend.tf": "terraform {\n  backend \"s3\" {}\n}",
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
	
	// Create a non-Terraform file that should be ignored
	ignoredFile := filepath.Join(tmpDir, "README.md")
	if err := ioutil.WriteFile(ignoredFile, []byte("# Test Module"), 0644); err != nil {
		t.Fatalf("Failed to write ignored file: %v", err)
	}
	
	// Test collecting Terraform files
	collected, err := collectTerraformFiles(tmpDir)
	if err != nil {
		t.Fatalf("collectTerraformFiles() error = %v", err)
	}
	
	// Check that we got the expected files
	if len(collected) != len(files) {
		t.Errorf("Expected %d files, got %d", len(files), len(collected))
	}
	
	// Check file contents
	for relPath, expectedContent := range files {
		content, ok := collected[relPath]
		if !ok {
			t.Errorf("Expected file %s not found in collected files", relPath)
			continue
		}
		
		if content != expectedContent {
			t.Errorf("File %s content mismatch:\nExpected: %s\nGot: %s", relPath, expectedContent, content)
		}
	}
	
	// Check that the ignored file was not included
	if _, ok := collected["README.md"]; ok {
		t.Errorf("Non-Terraform file README.md should not be included")
	}
}
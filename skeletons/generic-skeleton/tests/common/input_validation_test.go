package common_test

import (
	"os"
	"path/filepath"
	"regexp"
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// readTFVars reads and parses the terraform.tfvars file
func readTFVars(t *testing.T, exampleDir, example string) map[string]interface{} {
	tfvarsPath := filepath.Join(exampleDir, "terraform.tfvars")
	
	// Read the file content
	content, err := os.ReadFile(tfvarsPath)
	require.NoError(t, err, "Failed to read terraform.tfvars file")
	
	// Parse the file based on the example type
	if example == "basic" {
		// For basic example, parse simple key-value pairs
		vars := make(map[string]interface{})
		
		// Use regex to extract key-value pairs
		re := regexp.MustCompile(`(\w+)\s*=\s*"([^"]*)"`)
		matches := re.FindAllStringSubmatch(string(content), -1)
		
		for _, match := range matches {
			if len(match) == 3 {
				vars[match[1]] = match[2]
			}
		}
		
		return vars
	} else if example == "advanced" {
		// For advanced example, we need to handle the complex structure
		vars := make(map[string]interface{})
		
		// Extract file_permission and output_filename
		filePermRe := regexp.MustCompile(`file_permission\s*=\s*"([^"]*)"`)
		filePermMatch := filePermRe.FindStringSubmatch(string(content))
		if len(filePermMatch) == 2 {
			vars["file_permission"] = filePermMatch[1]
		}
		
		filenameRe := regexp.MustCompile(`output_filename\s*=\s*"([^"]*)"`)
		filenameMatch := filenameRe.FindStringSubmatch(string(content))
		if len(filenameMatch) == 2 {
			vars["output_filename"] = filenameMatch[1]
		}
		
		// Extract json_config values we care about
		messageRe := regexp.MustCompile(`message\s*=\s*"([^"]*)"`)
		messageMatch := messageRe.FindStringSubmatch(string(content))
		if len(messageMatch) == 2 {
			vars["message"] = messageMatch[1]
		}
		
		enabledRe := regexp.MustCompile(`enabled\s*=\s*(true|false)`)
		enabledMatch := enabledRe.FindStringSubmatch(string(content))
		if len(enabledMatch) == 2 {
			vars["enabled"] = enabledMatch[1] == "true"
		}
		
		retriesRe := regexp.MustCompile(`retries\s*=\s*(\d+)`)
		retriesMatch := retriesRe.FindStringSubmatch(string(content))
		if len(retriesMatch) == 2 {
			vars["retries"] = retriesMatch[1]
		}
		
		return vars
	}
	
	return nil
}

// TestInputsMatchProvisioned verifies that the inputs provided to the module
// match what was actually provisioned by Terraform
func TestInputsMatchProvisioned(t *testing.T) {
	examples := []string{"basic", "advanced"}
	
	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			// Get the example directory path
			exampleDir := filepath.Join("../../examples", example)
			
			// Read the terraform.tfvars file
			tfvars := readTFVars(t, exampleDir, example)
			
			// Run the example
			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: "input-validation-test-" + example,
			})
			
			// Get the outputs from the Terraform state
			outputs := terraform.OutputAll(t, ctx.Terraform)
			
			// Verify that output_content matches what was provided as input
			if example == "basic" {
				// For basic example, compare the output_content directly
				outputContent := outputs["output_content"]
				assert.Equal(t, tfvars["output_content"], outputContent, "output_content should match the input value")
			} else if example == "advanced" {
				// For advanced example, verify key fields in the parsed JSON
				jsonData := outputs["json_data"].(map[string]interface{})
				
				assert.Equal(t, tfvars["message"], jsonData["message"], "JSON message should match the input value")
				assert.Equal(t, tfvars["enabled"], jsonData["enabled"], "JSON enabled flag should match the input value")
				
				// Convert retries to float64 for comparison
				expectedRetries := 5.0 // We know it's 5 from the tfvars
				assert.Equal(t, expectedRetries, jsonData["retries"], "JSON retries should match the input value")
			}
			
			// Verify that output_filename is contained in output_file_path
			outputFilePath := outputs["output_file_path"].(string)
			expectedFilename := filepath.Base(tfvars["output_filename"].(string))
			assert.Contains(t, outputFilePath, expectedFilename, 
				"output_file_path should contain the input filename")
			
			// Verify that file_permission matches what was provided as input
			outputPermission := outputs["file_permission"]
			assert.Equal(t, tfvars["file_permission"], outputPermission, 
				"file_permission should match the input value")
		})
	}
}
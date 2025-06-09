package advanced_test

import (
	"encoding/json"
	"os"
	"path/filepath"
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/assertions"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestAdvancedOutput tests the advanced functionality of the module
// It verifies that the JSON file is created with the correct content
func TestAdvancedOutput(t *testing.T) {
	// Run the example without overriding variables - use values from terraform.tfvars
	ctx := testctx.RunSingleExample(t, "../../examples", "advanced", testctx.TestConfig{
		Name: "advanced",
	})
	
	// Verify file exists and has correct content
	filePath := terraform.Output(t, ctx.Terraform, "output_file_path")
	assert.NotEmpty(t, filePath, "File path should not be empty")
	
	assertions.AssertOutputContains(t, ctx, "output_content", "advanced")
	assertions.AssertOutputContains(t, ctx, "output_content", "true")
	
	// Get the json_data output directly - Terraform already returns this as a structured map
	jsonData := terraform.OutputForKeys(t, ctx.Terraform, []string{"json_data"})
	data := jsonData["json_data"].(map[string]interface{})
	
	// Verify specific fields
	assert.Equal(t, "advanced", data["message"], "JSON message should match expected value")
	assert.Equal(t, true, data["enabled"], "JSON enabled flag should match expected value")
}

// AssertJSONStructure is a custom assertion that checks if the JSON content has the expected structure
func AssertJSONStructure(t *testing.T, ctx testctx.TestContext, requiredKeys []string) {
	// Get the file content from the output
	content := terraform.Output(t, ctx.Terraform, "output_content")
	assertions.AssertOutputNotEmpty(t, ctx, "output_content")
	
	// Parse the JSON content
	var jsonData map[string]interface{}
	err := json.Unmarshal([]byte(content), &jsonData)
	assert.NoError(t, err, "Content should be valid JSON")
	
	// Check if all required keys exist
	for _, key := range requiredKeys {
		_, exists := jsonData[key]
		assert.True(t, exists, "JSON should contain key '%s'", key)
	}
	
	// Use the file path from the output to check the file
	filePath := terraform.Output(t, ctx.Terraform, "output_file_path")
	assert.NotEmpty(t, filePath, "Output file path should not be empty")
	
	// Construct the full path
	fullPath := filepath.Join(ctx.Terraform.TerraformDir, filePath)
	
	// Verify the file exists
	fileInfo, err := os.Stat(fullPath)
	assert.NoError(t, err, "File should exist at path: %s", fullPath)
	assert.False(t, fileInfo.IsDir(), "Path should be a file, not a directory: %s", fullPath)
	
	// Read the file content and verify it matches the output_content
	fileContent, err := os.ReadFile(fullPath)
	assert.NoError(t, err, "Should be able to read file: %s", fullPath)
	
	// Parse the file content as JSON to compare structure
	var fileJsonData map[string]interface{}
	err = json.Unmarshal(fileContent, &fileJsonData)
	assert.NoError(t, err, "File content should be valid JSON")
	
	// Check if all required keys exist in the file content
	for _, key := range requiredKeys {
		_, exists := fileJsonData[key]
		assert.True(t, exists, "File JSON should contain key '%s'", key)
	}
}

// TestAdvancedJSONStructure tests that the JSON file created by the advanced example has the expected structure
// This demonstrates a custom assertion for JSON structure validation
func TestAdvancedJSONStructure(t *testing.T) {
	// Run the example
	ctx := testctx.RunSingleExample(t, "../../examples", "advanced", testctx.TestConfig{
		Name: "advanced-json-test",
	})
	
	// Use our custom assertion to check JSON structure
	requiredKeys := []string{"message", "enabled", "retries"}
	AssertJSONStructure(t, ctx, requiredKeys)
}

// TestCollectionAssertions demonstrates collection assertions
// This test runs only on the advanced example which has structured JSON output
// It verifies various aspects of collection and JSON handling in the module
func TestCollectionAssertions(t *testing.T) {
	// Only run on advanced example which has JSON output
	ctx := testctx.RunSingleExample(t, "../../examples", "advanced", testctx.TestConfig{
		Name: "collection-assertions-test",
		ExtraVars: map[string]interface{}{
			// Provide a JSON config with nested structures for testing collection assertions
			"json_config": map[string]interface{}{
				"message": "advanced",
				"enabled": true,
				"retries": 5,
				"tags": map[string]interface{}{
					"Name":        "test",
					"Environment": "dev",
				},
				"regions": []string{"us-west-2", "us-east-1"},
			},
		},
	})
	
	// Collection Assertions
	// Verify that the json_data output map contains the key "tags"
	assertions.AssertOutputMapContainsKey(t, ctx, "json_data", "tags")
	
	// Verify that the "message" key in the json_data output map equals "advanced"
	assertions.AssertOutputMapKeyEquals(t, ctx, "json_data", "message", "advanced")
	
	// Verify that the regions_list output list contains the value "us-west-2"
	assertions.AssertOutputListContains(t, ctx, "regions_list", "us-west-2")
	
	// Verify that the regions_list output list has exactly 2 elements
	assertions.AssertOutputListLength(t, ctx, "regions_list", 2)
	
	// JSON Assertions
	// Verify that the output_content JSON string contains the key-value pair "enabled": true
	assertions.AssertOutputJSONContains(t, ctx, "output_content", "enabled", true)
}

// TestAdvancedJSONFormat verifies that the advanced example creates a valid JSON file
// with specific required fields and structure
// This is a unique test specific to the advanced example
func TestAdvancedJSONFormat(t *testing.T) {
	// Run the example
	ctx := testctx.RunSingleExample(t, "../../examples", "advanced", testctx.TestConfig{
		Name: "advanced-json-format-test",
	})
	
	// Store the content in a variable before any assertions that might cause cleanup
	content := terraform.Output(t, ctx.Terraform, "output_content")
	assert.NotEmpty(t, content, "Output content should not be empty")
	
	// Verify that the content is valid JSON
	var jsonData map[string]interface{}
	err := json.Unmarshal([]byte(content), &jsonData)
	assert.NoError(t, err, "Advanced example should output valid JSON")
	
	// Verify specific fields directly from the parsed JSON
	assert.Equal(t, "advanced", jsonData["message"], "JSON message should match expected value")
	assert.Equal(t, true, jsonData["enabled"], "JSON enabled flag should match expected value")
	assert.Equal(t, float64(5), jsonData["retries"], "JSON retries should match expected value")
	
	// Verify nested structures if they exist
	if tags, ok := jsonData["tags"].(map[string]interface{}); ok {
		assert.Contains(t, tags, "Name", "tags should contain 'Name' field")
		assert.Contains(t, tags, "Environment", "tags should contain 'Environment' field")
	} else {
		assert.Fail(t, "JSON should contain 'tags' as a map")
	}
	
	if regions, ok := jsonData["regions"].([]interface{}); ok {
		assert.GreaterOrEqual(t, len(regions), 1, "regions should contain at least one item")
	} else {
		assert.Fail(t, "JSON should contain 'regions' as an array")
	}
}
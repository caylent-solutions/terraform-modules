package advanced_test

import (
	"encoding/json"
	"os"
	"path/filepath"
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/caylent-solutions/terraform-terratest-framework/tests/unit"
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
	
	content := terraform.Output(t, ctx.Terraform, "output_content")
	assert.Contains(t, content, "advanced", "File content should contain expected value")
	assert.Contains(t, content, "true", "File content should contain expected value")
	
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
	assert.NotEmpty(t, content, "File content should not be empty")
	
	// Parse the JSON content
	var jsonData map[string]interface{}
	err := json.Unmarshal([]byte(content), &jsonData)
	assert.NoError(t, err, "Content should be valid JSON")
	
	// Check if all required keys exist
	for _, key := range requiredKeys {
		_, exists := jsonData[key]
		assert.True(t, exists, "JSON should contain key '%s'", key)
	}
	
	// Use the full path to check the file
	filePath := terraform.Output(t, ctx.Terraform, "output_file_path")
	fullPath := filepath.Join(ctx.Terraform.TerraformDir, filePath)
	
	// Verify the file exists
	_, err = os.Stat(fullPath)
	assert.NoError(t, err, "File should exist at path: %s", fullPath)
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
	unit.AssertOutputMapContainsKey(t, ctx, "json_data", "tags")
	
	// Verify that the "message" key in the json_data output map equals "advanced"
	unit.AssertOutputMapKeyEquals(t, ctx, "json_data", "message", "advanced")
	
	// Verify that the regions_list output list contains the value "us-west-2"
	unit.AssertOutputListContains(t, ctx, "regions_list", "us-west-2")
	
	// Verify that the regions_list output list has exactly 2 elements
	unit.AssertOutputListLength(t, ctx, "regions_list", 2)
	
	// JSON Assertions
	// Verify that the output_content JSON string contains the key-value pair "enabled": true
	unit.AssertOutputJSONContains(t, ctx, "output_content", "enabled", true)
}

// TestAdvancedJSONFormat verifies that the advanced example creates a valid JSON file
// with specific required fields and structure
// This is a unique test specific to the advanced example
func TestAdvancedJSONFormat(t *testing.T) {
	// Run the example
	ctx := testctx.RunSingleExample(t, "../../examples", "advanced", testctx.TestConfig{
		Name: "advanced-json-format-test",
	})
	
	// Get the output content
	content := terraform.Output(t, ctx.Terraform, "output_content")
	
	// Verify that the content is valid JSON
	var jsonData map[string]interface{}
	err := json.Unmarshal([]byte(content), &jsonData)
	assert.NoError(t, err, "Advanced example should output valid JSON")
	
	// Verify specific JSON structure unique to the advanced example
	assert.Contains(t, jsonData, "message", "JSON should contain 'message' field")
	assert.Contains(t, jsonData, "enabled", "JSON should contain 'enabled' field")
	assert.Contains(t, jsonData, "retries", "JSON should contain 'retries' field")
	
	// Verify data types of fields
	assert.IsType(t, "", jsonData["message"], "message should be a string")
	assert.IsType(t, true, jsonData["enabled"], "enabled should be a boolean")
	assert.IsType(t, float64(0), jsonData["retries"], "retries should be a number")
	
	// Verify nested structures if they exist
	if tags, ok := jsonData["tags"].(map[string]interface{}); ok {
		assert.Contains(t, tags, "Name", "tags should contain 'Name' field")
		assert.Contains(t, tags, "Environment", "tags should contain 'Environment' field")
	}
	
	if regions, ok := jsonData["regions"].([]interface{}); ok {
		assert.GreaterOrEqual(t, len(regions), 1, "regions should contain at least one item")
	}
}
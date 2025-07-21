package helpers

import (
	"strings"
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestContext represents the context for a Terraform test
// This is a wrapper around the framework's TestContext for backward compatibility
type TestContext struct {
	Terraform *terraform.Options
}

// AssertInputMatchesOutput verifies that a specific input variable matches the corresponding output
func AssertInputMatchesOutput(t *testing.T, ctx TestContext, inputName string, outputName string) {
	// Convert our TestContext to the framework's TestContext to use GetVariableAsMap
	frameworkCtx := testctx.TestContext{
		Terraform: ctx.Terraform,
	}

	// Get the input variable value using the framework's GetVariableAsMap method
	inputValue := frameworkCtx.GetVariableAsMap()[inputName]

	// Get the output value
	outputValue := terraform.Output(t, ctx.Terraform, outputName)

	// Verify that the input matches the output
	assert.Equal(t, inputValue, outputValue, "Input '%s' should match output '%s'", inputName, outputName)
}

// AssertAllInputsMatchOutputs verifies that all input variables match their corresponding outputs
// This assumes that for each input variable, there is an output with the same name
func AssertAllInputsMatchOutputs(t *testing.T, ctx TestContext, inputOutputMap map[string]string) {
	// Convert our TestContext to the framework's TestContext to use GetVariableAsMap
	frameworkCtx := testctx.TestContext{
		Terraform: ctx.Terraform,
	}

	// Get all input variables using the framework's GetVariableAsMap method
	inputs := frameworkCtx.GetVariableAsMap()

	// Get all outputs
	outputs := terraform.OutputAll(t, ctx.Terraform)

	// Verify each input-output pair
	for inputName, outputName := range inputOutputMap {
		inputValue, inputExists := inputs[inputName]
		assert.True(t, inputExists, "Input '%s' should exist", inputName)

		outputValue, outputExists := outputs[outputName]
		assert.True(t, outputExists, "Output '%s' should exist", outputName)

		assert.Equal(t, inputValue, outputValue, "Input '%s' should match output '%s'", inputName, outputName)
	}
}

// AssertResourceExists verifies that at least one instance of a given resource type exists in the Terraform state
func AssertResourceExists(t *testing.T, terraformOptions *terraform.Options, resourceType string) {
	stateOutput, err := terraform.RunTerraformCommandE(t, terraformOptions, "state", "list")
	if err != nil {
		t.Fatalf("Failed to list terraform state: %v", err)
	}

	resourceCount := strings.Count(stateOutput, resourceType)
	if resourceCount == 0 {
		t.Fatalf("Expected at least 1 %s resource, found 0. State contents: %s", resourceType, stateOutput)
	}
}

// AssertResourceCountExact verifies the exact number of a specific resource type in the state
func AssertResourceCountExact(t *testing.T, terraformOptions *terraform.Options, resourceType string, expectedCount int) {
	stateOutput, err := terraform.RunTerraformCommandE(t, terraformOptions, "state", "list")
	if err != nil {
		t.Fatalf("Failed to list terraform state: %v", err)
	}

	actualCount := strings.Count(stateOutput, resourceType)
	if actualCount != expectedCount {
		t.Fatalf("Expected exactly %d %s resources, found %d. State contents: %s", expectedCount, resourceType, actualCount, stateOutput)
	}
}

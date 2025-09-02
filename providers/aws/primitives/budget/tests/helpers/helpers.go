package helpers

import (
	"reflect"
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

// LoadTfVarFile returns the .tfvars file passed through the vf variable as a map[string]interface{}
func LoadTfVarFile(t *testing.T, ctx TestContext, vf string) map[string]interface{} {

	vars := map[string]interface{}{}
	terraform.GetAllVariablesFromVarFile(t, vf, &vars)
	return vars
}

// AssertInputsMapMatchOutputsMap verifies that an input map variables match their corresponding outputs map
// This assumes that for each input variable, there is an output with the same name
func AssertInputsMapMatchOutputsMap(t *testing.T, ctx TestContext, varFile string, inputOutputName string, attrList []string) {
	// Convert our TestContext to the framework's TestContext to use GetVariableAsMap

	inputs := LoadTfVarFile(t, ctx, varFile)

	inputMap, inputMapExists := inputs[inputOutputName].(map[string]interface{})
	assert.True(t, inputMapExists, "Input variable '%s' should be of type object (map)", inputOutputName)

	// Get all outputs
	outputs := terraform.OutputAll(t, ctx.Terraform)
	// outputMap := outputs[inputOutputName]

	outputMap, outputMapExists := outputs[inputOutputName].(map[string]interface{})
	assert.True(t, outputMapExists, "Output '%s' should be of type object (map)", inputOutputName)

	// Verify each input-output pair
	for inputKey, inputValue := range inputMap {
		inputObj, inputValueExists := inputValue.(map[string]interface{})
		assert.True(t, inputValueExists, "Inputs.%q[%q] must be an object", inputOutputName, inputKey)

		outputValue, outputKeyExists := outputMap[inputKey]
		assert.True(t, outputKeyExists, "outputs.%q is missing key %q", inputOutputName, inputKey)

		outputObj, outputValueExists := outputValue.(map[string]interface{})
		assert.True(t, outputValueExists, "outputs.%q[%q] must be an object", inputOutputName, outputValue)

		for _, attr := range attrList {
			inputAttr, inputAttrExists := inputObj[attr]
			assert.True(t, inputAttrExists, "Inputs.%q[%q].%q missing", inputOutputName, inputKey, attr)

			outputAttr, outputAttrExists := outputObj[attr]
			assert.True(t, outputAttrExists, "Inputs.%q[%q].%q missing", inputOutputName, inputKey, attr)

			if reflect.TypeOf(inputAttr).Kind() == reflect.Float64 {

			}

			assert.Equal(t, inputAttr, outputAttr, "Mismatch in %q.[%q].%q", inputOutputName, inputKey, attr)
		}

	}
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

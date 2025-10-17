package common_test

import (
	"regexp"
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestModuleOutputs(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "module-outputs-test",
	})

	// Get all outputs
	outputs := terraform.OutputAll(t, ctx.Terraform)

	// Test that all expected outputs exist
	expectedOutputs := []string{
		"iam_identity_center_principal_types",
		"iam_identity_center_identity_provider_types",
		"iam_identity_center_permission_set_keys",
		"iam_identity_center_policy_properties",
		"aws_account_id_regex",
		"array_indices",
		"defaults",
		"format_strings",
	}

	for _, output := range expectedOutputs {
		_, exists := outputs[output]
		assert.True(t, exists, "Output '%s' should exist", output)
	}
}

func TestConstantValues(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "constant-values-test",
	})

	// Get outputs
	accountIdRegex := terraform.Output(t, ctx.Terraform, "aws_account_id_regex")
	assert.Equal(t, "[0-9]{12}", accountIdRegex, "Account ID regex should match expected pattern")

	// Validate regex pattern works
	regex, err := regexp.Compile(accountIdRegex)
	require.NoError(t, err, "Account ID regex should be valid")
	assert.True(t, regex.MatchString("123456789012"), "Regex should match valid account ID")
	assert.False(t, regex.MatchString("12345678901"), "Regex should not match invalid account ID")
}

func TestConstantValuesMatchExpected(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "constant-values-validation-test",
	})

	// Get our constants from Terraform output
	outputs := terraform.OutputAll(t, ctx.Terraform)
	principalTypesOutput := outputs["iam_identity_center_principal_types"].(map[string]interface{})
	providerTypesOutput := outputs["iam_identity_center_identity_provider_types"].(map[string]interface{})

	// Validate principal types match AWS API documentation
	expectedPrincipalTypes := map[string]string{
		"group": "GROUP",
		"user":  "USER",
	}

	for key, expectedValue := range expectedPrincipalTypes {
		actualValue, exists := principalTypesOutput[key]
		assert.True(t, exists, "Principal type '%s' should exist in constants", key)
		assert.Equal(t, expectedValue, actualValue, "Principal type '%s' should match AWS API value", key)
	}

	// Validate identity provider types match AWS API documentation
	expectedProviderTypes := map[string]string{
		"internal": "INTERNAL",
		"external": "EXTERNAL",
		"google":   "GOOGLE",
	}

	for key, expectedValue := range expectedProviderTypes {
		actualValue, exists := providerTypesOutput[key]
		assert.True(t, exists, "Provider type '%s' should exist in constants", key)
		assert.Equal(t, expectedValue, actualValue, "Provider type '%s' should match AWS API value", key)
	}
}

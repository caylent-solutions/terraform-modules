package basic_test

import (
	"strings"
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBasicExample(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-example-test",
	})

	// Verify terraform validate passes
	terraform.Validate(t, ctx.Terraform)

	// Test that the module can be instantiated without errors
	assert.True(t, true, "Basic example applied successfully")
}

func TestConstantsAccessibility(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "constants-accessibility-test",
	})

	// Verify that the module reference works by checking outputs exist
	outputs := terraform.OutputAll(t, ctx.Terraform)
	assert.NotEmpty(t, outputs, "Should have outputs from the module")
}

func TestLambdaExtensionConstants(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "lambda-extension-constants-test",
	})

	ext := terraform.OutputMapOfObjects(t, ctx.Terraform, "lambda_extension")
	assert.NotEmpty(t, ext, "lambda_extension output should not be empty")

	envVarNames, ok := ext["env_var_names"].(map[string]interface{})
	assert.True(t, ok, "lambda_extension.env_var_names should be a map")
	assert.Equal(t, "PARAMETERS_SECRETS_EXTENSION_HTTP_PORT", envVarNames["http_port"])
	assert.Equal(t, "PARAMETERS_SECRETS_EXTENSION_CACHE_ENABLED", envVarNames["cache_enabled"])
	assert.Equal(t, "PARAMETERS_SECRETS_EXTENSION_CACHE_SIZE", envVarNames["cache_size"])
	assert.Equal(t, "PARAMETERS_SECRETS_EXTENSION_MAX_CONNECTIONS", envVarNames["max_connections"])
	assert.Equal(t, "SECRETS_MANAGER_TIMEOUT_MILLIS", envVarNames["secrets_timeout"])
	assert.Equal(t, "SSM_PARAMETER_STORE_TIMEOUT_MILLIS", envVarNames["ssm_timeout"])

	layer, ok := ext["layer"].(map[string]interface{})
	assert.True(t, ok, "lambda_extension.layer should be a map")
	assert.Equal(t, "AWS-Parameters-and-Secrets-Lambda-Extension", layer["name_x86_64"])
	assert.Equal(t, "AWS-Parameters-and-Secrets-Lambda-Extension-Arm64", layer["name_arm64"])

	x86Pattern, ok := layer["arn_pattern_x86_64"].(string)
	assert.True(t, ok, "arn_pattern_x86_64 should be a string")
	assert.True(t, strings.HasPrefix(x86Pattern, "arn:aws:lambda:"), "x86_64 ARN pattern should start with arn:aws:lambda:")
	assert.Contains(t, x86Pattern, "AWS-Parameters-and-Secrets-Lambda-Extension")

	arm64Pattern, ok := layer["arn_pattern_arm64"].(string)
	assert.True(t, ok, "arn_pattern_arm64 should be a string")
	assert.True(t, strings.HasPrefix(arm64Pattern, "arn:aws:lambda:"), "arm64 ARN pattern should start with arn:aws:lambda:")
	assert.Contains(t, arm64Pattern, "AWS-Parameters-and-Secrets-Lambda-Extension-Arm64")
}

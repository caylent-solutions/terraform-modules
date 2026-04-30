package helpers

import (
	"regexp"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// AssertWebACLArnFormat verifies that the Web ACL ARN matches the expected AWS WAFv2 format.
func AssertWebACLArnFormat(t *testing.T, terraformOptions *terraform.Options, outputName string) {
	t.Helper()

	arn := terraform.Output(t, terraformOptions, outputName)
	assert.NotEmpty(t, arn, "output '%s' must not be empty", outputName)

	matched, err := regexp.MatchString(
		`^arn:aws:wafv2:[a-z0-9-]+:[0-9]{12}:regional/webacl/[^/]+/[a-f0-9-]{36}$`,
		arn,
	)
	assert.NoError(t, err, "regex must compile")
	assert.True(t, matched, "output '%s' value '%s' does not match WAFv2 regional webacl ARN format", outputName, arn)
}

// AssertOutputNotEmpty verifies that a Terraform output is not empty.
func AssertOutputNotEmpty(t *testing.T, terraformOptions *terraform.Options, outputName string) {
	t.Helper()

	value := terraform.Output(t, terraformOptions, outputName)
	assert.NotEmpty(t, value, "output '%s' must not be empty", outputName)
}

// AssertOutputEmpty verifies that a Terraform output is empty.
func AssertOutputEmpty(t *testing.T, terraformOptions *terraform.Options, outputName string) {
	t.Helper()

	value := terraform.Output(t, terraformOptions, outputName)
	assert.Empty(t, value, "output '%s' must be empty, got: '%s'", outputName, value)
}

// AssertResourceCountExact verifies the exact number of a specific resource type in Terraform state.
func AssertResourceCountExact(t *testing.T, terraformOptions *terraform.Options, resourceType string, expectedCount int) {
	t.Helper()

	stateOutput, err := terraform.RunTerraformCommandE(t, terraformOptions, "state", "list")
	assert.NoError(t, err, "terraform state list must succeed")

	actualCount := strings.Count(stateOutput, resourceType)
	assert.Equal(t, expectedCount, actualCount,
		"expected %d '%s' resources in state, found %d. State:\n%s",
		expectedCount, resourceType, actualCount, stateOutput,
	)
}

// AssertStateContains verifies that the Terraform state contains a specific resource path.
func AssertStateContains(t *testing.T, terraformOptions *terraform.Options, resourcePath string) {
	t.Helper()

	stateOutput, err := terraform.RunTerraformCommandE(t, terraformOptions, "state", "list")
	assert.NoError(t, err, "terraform state list must succeed")
	assert.Contains(t, stateOutput, resourcePath,
		"expected state to contain '%s'. State:\n%s", resourcePath, stateOutput,
	)
}

package common_test

import (
	"testing"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/assertions"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestTerraformValidate runs 'terraform validate' on all examples
// This test ensures that the Terraform code is syntactically valid
func TestTerraformValidate(t *testing.T) {
	examples := []string{"basic"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			// Run the example
			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: "validate-test-" + example,
			})

			// Run terraform validate
			terraform.Validate(t, ctx.Terraform)
		})
	}
}

// TestTerraformFormat checks if the Terraform code is properly formatted
// This test ensures that the Terraform code follows consistent formatting
func TestTerraformFormat(t *testing.T) {
	examples := []string{"basic"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			// Run the example
			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: "format-test-" + example,
			})

			// Check if terraform code is formatted
			output, err := terraform.RunTerraformCommandE(t, ctx.Terraform, "fmt", "-check", "-recursive")
			assert.Empty(t, output, "Terraform code should be properly formatted")
			assert.NoError(t, err, "Terraform fmt should not fail")
		})
	}
}

// TestRequiredOutputs checks that required outputs are defined
// This test ensures that all required outputs are present in the module
func TestRequiredOutputs(t *testing.T) {
	examples := []string{"basic"}
	requiredOutputs := []string{"budgets"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			// Run the example
			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: "outputs-test-" + example,
			})

			// Check required outputs
			outputs := terraform.OutputAll(t, ctx.Terraform)

			for _, output := range requiredOutputs {
				_, exists := outputs[output]
				assert.True(t, exists, "Required output '%s' should be defined", output)
			}
		})
	}
}

// TestAllAssertionTypes demonstrates all the assertion types available in the framework
// This test runs on both the basic and advanced examples to verify various aspects of the module
func TestAllAssertionTypes(t *testing.T) {
	examples := []string{"basic"}

	for _, example := range examples {
		t.Run(example, func(t *testing.T) {
			// Run the example
			ctx := testctx.RunSingleExample(t, "../../examples", example, testctx.TestConfig{
				Name: "assertions-test-" + example,
			})

			// Basic Assertions
			// Verify that the budgets output is not empty
			assertions.AssertOutputNotEmpty(t, ctx, "budgets")

			// Environment Assertions
			// Verify that the Terraform version is at least 1.12.0
			assertions.AssertTerraformVersion(t, ctx, "1.12.0")

			// Idempotency is automatically tested by the framework when using RunSingleExample
			// This verifies that running terraform plan after apply shows no changes
			// assertions.AssertIdempotent(t, ctx)
		})
	}
}

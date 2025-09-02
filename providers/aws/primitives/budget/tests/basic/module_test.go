package basic_test

import (
	"testing"

	"github.com/caylent-solutions/terraform-modules/providers/aws/primitives/budget/tests/helpers"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/assertions"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

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

// TestBudgetResourceExist tests that the budget exists in the state
func TestBudgetResourceExist(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-budget-resource-exist",
	})

	// Verify Budgets are created
	helpers.AssertResourceExists(t, ctx.Terraform, "aws_budgets_budget")
	helpers.AssertResourceCountExact(t, ctx.Terraform, "aws_budgets_budget", 2)

}

// TestBasicBudgetConfiguration tests the basic Budget configuration
func TestBasicBudgetConfiguration(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-budget-config-test",
	})

	// Verify module outputs are created and output keys exist
	assertions.AssertOutputNotEmpty(t, ctx, "budgets")
	assertions.AssertOutputMapContainsKey(t, ctx, "budgets", "monthly-cost-budget")
	assertions.AssertOutputMapContainsKey(t, ctx, "budgets", "all-options-budget")

	// Verify input variables values match the created resource
	helpers.AssertInputsMapMatchOutputsMap(t, helpers.TestContext{Terraform: ctx.Terraform},
		"../../examples/basic/terraform.tfvars",
		"budgets",
		[]string{"name", "budget_type"},
	)
}

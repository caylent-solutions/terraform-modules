package basic_test

import (
	"testing"

	"github.com/caylent-solutions/terraform-modules/providers/aws/primitives/budget/tests/helpers"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/assertions"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
)

// TestBudgetResourceExist tests that the budget exists in the state
func TestBudgetResourceExist(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-budget-resource-exist",
	})

	helpers.AssertResourceExists(t, ctx.Terraform, "aws_budgets_budget")
}

// TestBasicBudgetConfiguration tests the basic Budget configuration
func TestBasicBudgetConfiguration(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-budget-config-test",
	})

	// Verify basic Budget properties
	assertions.AssertOutputNotEmpty(t, ctx, "budget_name")
	assertions.AssertOutputNotEmpty(t, ctx, "budget_arn")
	assertions.AssertOutputMatches(t, ctx, "budget_arn", "^arn:aws:budgets::[0-9]{12}:budget/[^:\\\\]+$")

	// Verify basic Budget functionalities
	assertions.AssertOutputNotEmpty(t, ctx, "budget_notifications")
	assertions.AssertOutputNotEmpty(t, ctx, "budget_cost_filter")
}

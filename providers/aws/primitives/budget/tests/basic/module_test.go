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

// TestBudgetResourceCount tests that three budgets are created
func TestBudgetResourceCount(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-budget-resource-count-test",
	})

	helpers.AssertResourceCountExact(t, ctx.Terraform, "aws_budgets_budget", 3)
}

// TestBudgetOutputmapKeys test that the budget names match the ones on the example
func TestBudgetOutputmapKeys(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-budget-monthly-cost-test",
	})

	assertions.AssertOutputMapContainsKey(t, ctx, "budgets", "monthly-cost-budget-basic")
	assertions.AssertOutputMapContainsKey(t, ctx, "budgets", "linked-account-budget-basic")
	assertions.AssertOutputMapContainsKey(t, ctx, "budgets", "all-options-budget-basic")
}

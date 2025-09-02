# Test Helpers

This directory contains helper functions that can be used across all tests.

## Helper Functions

### `helpers.go`

This file contains all helper functions for tests:

#### Input Validation

- **AssertInputsMapMatchOutputsMap**: Verifies that a specific input map variable matches the corresponding output map
- **AssertAllInputsMatchOutputs**: Verifies that all input variables match their corresponding outputs based on a provided mapping
- **AssertResourceExists**: Verifies that the resource is created in the state
- **AssertResourceCountExact**: Verifies that the resource exists in the state an exact amount of times


## Usage

To use these helpers in your tests:

```go
import (
    "testing"
    
    "github.com/your-org/terraform-modules/skeletons/generic-skeleton/tests/helpers"
    "github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
    "github.com/gruntwork-io/terratest/modules/terraform"
)

// TestBudgetResourceExist tests that the budget exists in the state
func TestExample(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-test-resource-exist",
	})

	// Verify Budgets are created
	helpers.AssertResourceExists(t, ctx.Terraform, "aws_budgets_budget")
	helpers.AssertResourceCountExact(t, ctx.Terraform, "aws_budgets_budget", 2)

}
```

## Note on Input Validation

For more robust input validation, consider using the approach in `input_validation_test.go` which reads inputs directly from terraform.tfvars files and compares them with outputs. This approach is more reliable than trying to access input variables through the Terraform context.
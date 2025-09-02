# Basic Example Functional Tests

This directory contains tests specific to the basic example of the module.

## Test Files

### `module_test.go`

This file contains all tests specific to the basic example:

1. **TestTerraformFormat**: Tests if the Terraform code is properly formatted.
2. **TestTerraformValidate**: Tests ensures that the Terraform code is syntactically valid.  
1. **TestBudgetResourceExist**: Tests that the budget resource exists in the state
2. **TestBasicBudgetConfiguration**: Tests that the budget module is created correctly and outputs the required values.  


## Example Configuration

The basic example uses:
- `variables.tf` to define variables with default values
- `terraform.tfvars` to set actual values for the example
- `main.tf` to reference variables instead of hardcoded values

This approach makes the example more maintainable and allows for dynamic testing.

## Running the Tests

To run these tests:

```bash
# Run tests for the basic example
tftest run --example-path basic

# Or using Go test directly
cd /path/to/module
go test ./tests/basic
```

For more information on the `tftest` CLI tool, see the [CLI Usage Documentation](https://github.com/caylent-solutions/terraform-terratest-framework/blob/main/docs/CLI_USAGE.md).
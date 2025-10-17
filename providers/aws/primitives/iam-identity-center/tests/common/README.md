# Common Functional Tests

This directory contains common tests that run on all examples in the IAM Identity Center module.

## Test Files

### `module_test.go`

Contains non-destructive tests that verify basic functionality:

1. **TestTerraformValidate**: Verifies Terraform code is syntactically valid
2. **TestTerraformFormat**: Checks Terraform code formatting
3. **TestTerraformPlan**: Verifies Terraform plan succeeds without creating resources

These tests do NOT create actual AWS resources, making them safe to run in any AWS account.

## Running the Tests

```bash
# Run only common tests
make test-common

# Run a specific test
go test ./tests/common -run '^TestTerraformValidate$'
```

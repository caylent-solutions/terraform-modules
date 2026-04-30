# API Gateway REST API Module Tests

This directory contains tests for the `api-gateway-rest-api` Terraform module using the
[Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Test Structure

- **basic/**: Tests for the basic example (Regional REST API with default settings)

## Running Tests

Tests can be run using the provided Makefile commands:

```bash
# Run all tests
make test

# Lint Go test files
make go-lint

# Format Go test files
make go-format

# Clean up temporary files
make clean
```

## Test Requirements

- Go >= 1.24.4
- Terraform >= 1.12.1
- AWS credentials configured (role ARN via `AWS_GITHUB_ACTIONS_ROLE_ARN` environment variable)
- All Go test files must pass linting (`make go-lint`)
- All Go test files must be properly formatted (`make go-format`)

## Writing Tests

See the README.md in each test directory for information on specific tests and how to write new ones.
Tests use the Terratest framework's `testctx.RunSingleExample` pattern to provision real AWS resources,
assert outputs, and destroy resources after each test run.

# Module Tests

This directory contains tests for the Terraform module using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Test Structure

The tests are organized into the following directories:

- **common/**: Tests that run on all examples
- **basic/**: Tests for the basic example
- **advanced/**: Tests for the advanced example
- **helpers/**: Helper functions for tests

## Running Tests

Tests can be run using the provided Makefile commands:

```bash
# Run all tests
make test

# Run tests for a specific example
make test-basic
make test-advanced

# Run only common tests
make test-common

# Lint Go test files
make go-lint

# Format Go test files
make go-format

# Clean up temporary files
make clean
```

## Test Requirements

- Go >= 1.23
- Terraform >= 1.12.1
- AWS credentials configured (if testing AWS resources)
- All Go test files must pass linting (`make go-lint`)
- All Go test files must be properly formatted (`make go-format`)

## Writing Tests

See the README.md in each test directory for information on the specific tests and how to write new ones.
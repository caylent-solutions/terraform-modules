# DynamoDB Table Module Tests

This directory contains tests for the DynamoDB Table Terraform module using the
[Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Test Structure

- **basic/**: Tests for the basic example (PAY_PER_REQUEST table with PITR)

## Running Tests

Tests can be run using the provided Makefile commands:

```bash
# Configure CPM and install dependencies first
make cpm-configure
make install

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
- AWS credentials configured with sufficient permissions to create DynamoDB tables
- All Go test files must pass linting (`make go-lint`)
- All Go test files must be properly formatted (`make go-format`)

## Writing Tests

See the README.md in the basic directory for information on the specific tests
and how to write new ones.

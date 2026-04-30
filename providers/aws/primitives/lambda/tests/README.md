# Module Tests

This directory contains tests for the Terraform module using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Test Structure

The tests are organized into the following directories:

- **common/**: Tests that run assertions common to all deployment types (uses the zip example)
- **lambda-zip-deployment/**: Tests specific to the zip-based Lambda deployment example
- **lambda-docker-deployment/**: Tests specific to the Docker/Image-based Lambda deployment example
- **helpers/**: Helper functions shared across tests

## Running Tests

Tests can be run using the provided Makefile commands:

```bash
# Run all tests
make test

# Run tests for the zip-deployment example
make test-lambda-zip-deployment

# Run tests for the docker-deployment example
make test-lambda-docker-deployment

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

- Go >= 1.24.4
- Terraform >= 1.12.1
- AWS credentials configured (if testing AWS resources)
- All Go test files must pass linting (`make go-lint`)
- All Go test files must be properly formatted (`make go-format`)

## Writing Tests

See the README.md in each test directory for information on the specific tests and how to write new ones.

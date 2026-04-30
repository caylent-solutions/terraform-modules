# SQS Queue Module Tests

This directory contains tests for the `sqs-queue` Terraform primitive module using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Test Structure

- **basic/**: Tests for the basic example (queue with DLQ and CloudWatch alarm)

## Running Tests

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

- Go >= 1.24
- Terraform >= 1.12.1
- AWS credentials configured
- All Go test files must pass linting (`make go-lint`)
- All Go test files must be properly formatted (`make go-format`)

## Writing Tests

See the README.md in the `basic/` directory for information on the specific tests and how to write new ones.

# Route53 Record Module Tests

This directory contains tests for the route53-record Terraform module using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Test Structure

- **basic/** -- Tests for the basic A record example
- **helpers/** -- Shared helper functions used across test suites

## Running Tests

```bash
# Run all tests (from module root)
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
- AWS credentials configured with Route53 permissions
- All Go test files must pass linting (`make go-lint`)
- All Go test files must be properly formatted (`make go-format`)

## Writing Tests

See the README.md in the `basic/` directory for information on the specific tests and how to write new ones.

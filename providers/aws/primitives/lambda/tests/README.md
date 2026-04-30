# Module Tests

This directory contains tests for the Terraform module using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Test Structure

The tests are organized into the following directories:

- **common/**: Tests that run on all examples
- **lambda-zip-deployment/**: Tests for the `examples/lambda-zip-deployment/` example
- **lambda-docker-deployment/**: Tests for the `examples/lambda-docker-deployment/` example
- **helpers/**: Helper functions used by the per-example test packages

## Running Tests

Tests are driven via the repo-root Makefile (which sources
`test.config` for `GO_TEST_TIMEOUT` and `TERRATEST_IDEMPOTENCY` and
invokes `tftest run` inside the module):

```bash
# Run all tests for this module (sequential fixtures and tests)
make tf-test MODULE_PATH=providers/aws/primitives/lambda

# Run only the common tests
cd providers/aws/primitives/lambda && make test-common

# Format / lint Go test files
cd providers/aws/primitives/lambda && make go-format
cd providers/aws/primitives/lambda && make go-lint
```

## Test Requirements

- Go >= 1.23
- Terraform >= 1.12.1
- AWS credentials configured (if testing AWS resources)
- All Go test files must pass linting (`make go-lint`)
- All Go test files must be properly formatted (`make go-format`)

## Writing Tests

See the README.md in each test directory for information on the specific tests and how to write new ones.
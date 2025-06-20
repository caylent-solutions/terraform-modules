# Terraform Module Testing Requirements

All Terraform modules in this repository must include comprehensive functional tests using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Testing Framework

The Caylent Solutions Terraform Terratest Framework is a Go-based testing framework specifically designed for testing Terraform modules. It provides:

- A structured approach to testing Terraform modules
- Helper functions and assertions for common testing scenarios
- Support for testing multiple examples in parallel
- Automatic idempotency testing
- Benchmarking capabilities

## Test Structure Requirements

Each module must follow the test structure defined in the skeleton module:

```
module/
├── tests/
│   ├── common/              # Tests that run on all examples
│   │   ├── module_test.go   # Common tests (validation, formatting, outputs)
│   │   └── README.md        # Documentation for common tests
│   ├── [example-name]/      # Tests for each example (one directory per example)
│   │   ├── module_test.go   # Example-specific tests
│   │   └── README.md        # Documentation for example-specific tests
│   ├── helpers/             # Helper functions for tests (optional)
│   │   ├── helpers.go       # Helper functions
│   │   └── README.md        # Documentation for helpers
│   └── README.md            # Overview of the test suite
├── test.config              # Module-specific test configuration
```

## Required Test Types

At a minimum, each module must include the following tests:

1. **Common Tests** (in `tests/common/module_test.go`):
   - Terraform validation tests
   - Terraform formatting tests
   - Required outputs tests
   - Resource existence tests
   - Idempotency tests (automatically included by the framework)
   - Input validation tests

2. **Example-Specific Tests** (in `tests/[example-name]/module_test.go`):
   - Functional tests specific to each example
   - Tests that verify the module's core functionality
   - Tests for specific features demonstrated in the example

## Test Configuration

Each module must include a `test.config` file in its root directory to control test behavior:

```bash
# Test configuration for this module
# This file controls test behavior settings

# Set to true or false to enable/disable idempotency testing
TERRATEST_IDEMPOTENCY=true

# Add other test configuration settings below
```

This configuration file allows module authors to:
- Control idempotency testing by setting TERRATEST_IDEMPOTENCY to true or false
- Add other test-specific configuration settings

The TERRATEST_IDEMPOTENCY variable is loaded by the main Makefile and passed to the module's Makefile when running tests with `make tf-test`. The terraform-terratest-framework uses this environment variable to determine whether to run idempotency tests.

## Writing Tests

Tests should be written in Go using the Terraform Terratest Framework. The framework provides:

1. **TestCtx Package**: Core functionality for running and managing Terraform tests
   ```go
   ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
       Name: "basic-test",
   })
   ```

2. **Assertions Package**: Helper functions for verifying Terraform outputs and resources
   ```go
   assertions.AssertOutputEquals(t, ctx, "output_name", "expected_value")
   assertions.AssertResourceExists(t, ctx, "resource_type", "resource_name")
   ```

3. **Custom Assertions**: Module-specific assertions for unique functionality
   ```go
   func AssertCustomFunctionality(t *testing.T, ctx testctx.TestContext) {
       // Custom assertion logic
   }
   ```

## Running Tests

Tests can be run using the provided Makefile commands:

```bash
# Install dependencies
make install

# Run all tests
make test

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
- The terraform-terratest-framework installed via `make install`
- All Go test files must pass linting (`make go-lint`)
- All Go test files must be properly formatted (`make go-format`)

## Controlling Idempotency Testing

Idempotency testing ensures that applying the same Terraform code multiple times produces the same result. This is an important property for Terraform modules, but in some cases it may not be applicable or may cause issues.

To control idempotency testing:

1. Edit the `test.config` file in the module root directory
2. Set `TERRATEST_IDEMPOTENCY=false` to disable idempotency testing
3. Set `TERRATEST_IDEMPOTENCY=true` to enable idempotency testing

When running tests with `make tf-test`, the main Makefile loads this setting from test.config and passes it to the module's Makefile, which then sets it as an environment variable for the terraform-terratest-framework. The framework uses this environment variable to determine whether to run idempotency tests.

## Example Test Cases

The skeleton module includes example tests that demonstrate:

1. **Basic Validation**: Ensuring the module is syntactically valid
2. **Output Verification**: Checking that outputs match expected values
3. **Resource Verification**: Ensuring resources are created correctly
4. **Idempotency**: Verifying that applying the same code multiple times produces the same result
5. **Input Validation**: Ensuring inputs are properly processed by the module

## Best Practices

1. **Test All Examples**: Each example in the `examples/` directory must have corresponding tests
2. **Test Core Functionality**: Tests should verify that the module's core functionality works as expected
3. **Test Edge Cases**: Include tests for edge cases and error conditions
4. **Document Tests**: Include README.md files explaining the tests and how to run them
5. **Keep Tests Independent**: Each test should be independent and not rely on the state from other tests

## References

- [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework)
- [Skeleton Module Tests](../skeletons/generic-skeleton/tests)
# OPA Unit Tests

This directory contains unit tests for OPA policies in the repository.

## Structure

- `global/`: Tests for global policies
- `terraform/`: Tests for Terraform-specific policies
  - `module/`: Tests for module policies
  - `module_types/`: Tests for module type-specific policies
  - `provider/`: Tests for provider policies
- `helpers/`: Helper functions for tests

## Running Tests

You can run the tests using the `make` commands:

```bash
# Run all tests without coverage
make rego-unit-test

# Run all tests with text coverage
make rego-unit-test-coverage

# Run all tests with JSON coverage
make rego-unit-test-coverage-json
```

## Writing Tests

Each test file should:
- Match the structure: `<original filename>_test.rego`
- Import the policy and helpers:
  ```rego
  import data.<policy_package> as policy
  import data.tests.helpers as helpers
  ```
- Include `test_` prefixed rules for both pass and fail cases
- Use inputs from `helpers` wherever applicable

Example:

```rego
package terraform.module.version.test

import data.terraform.module.version as policy
import data.tests.helpers as helpers

# Test that missing versions.tf violates the policy
test_missing_versions_tf_violation {
    # Mock input with no versions.tf
    module_path := "modules/test-module"
    files := {
        "modules/test-module/main.tf": "resource \"aws_s3_bucket\" \"test\" {}"
    }
    input := helpers.mock_terraform_module_input(module_path, files)
    
    # Check for violations
    violations := policy.violation with input as input
    
    # Expect one violation
    count([v | v := violations[_]; v.message == "Missing versions.tf file"]) == 1
}
```
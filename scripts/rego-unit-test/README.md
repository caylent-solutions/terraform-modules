# Rego Unit Test Runner

This script runs Rego unit tests for OPA policies in the repository.

## Usage

```bash
# Run tests without coverage
go run main.go --no-coverage --data-path /path/to/repo /path/to/monorepo-config.json

# Run tests with text coverage (human-readable format)
go run main.go --coverage-text --data-path /path/to/repo /path/to/monorepo-config.json

# Run tests with JSON coverage (machine-readable format)
go run main.go --coverage-json --data-path /path/to/repo /path/to/monorepo-config.json
```

## Makefile Integration

The script is integrated into the repository's Makefile with the following targets:

```bash
# Run tests without coverage
make rego-unit-test

# Run tests with text coverage
make rego-unit-test-coverage

# Run tests with JSON coverage
make rego-unit-test-coverage-json
```

Additional Rego-related tasks:

```bash
# Check Rego files for linting issues
make rego-lint

# Fix Rego formatting issues
make rego-format
```

## Configuration

The script reads configuration from the monorepo-config.json file:

```json
{
  "rego_tests": [
    "tests/opa/unit/global",
    "tests/opa/unit/terraform/module",
    "tests/opa/unit/terraform/module_types",
    "tests/opa/unit/terraform/provider"
  ],
  "rego_policy_dirs": {
    "tests/opa/unit/global": "policies/opa/global",
    "tests/opa/unit/terraform/module": "policies/opa/terraform/module",
    "tests/opa/unit/terraform/module_types": "policies/opa/terraform/module_types",
    "tests/opa/unit/terraform/provider": "policies/opa/terraform/provider"
  },
  "rego_helpers_dir": "tests/opa/unit/helpers"
}
```

- `rego_tests`: List of directories containing test files
- `rego_policy_dirs`: Mapping of test directories to policy directories
- `rego_helpers_dir`: Path to helper files used by tests

## Coverage Reports

### Text Coverage Format

The text coverage report provides a human-readable summary of test coverage:

```
Coverage for tests/opa/unit/global:
/workspaces/terraform-modules/tests/opa/unit/helpers/helpers.rego        66.7%
policies/opa/global/empty_pr_policy.rego                                100.0%
policies/opa/global/license_policy.rego                                  67.4%
tests/opa/unit/global/empty_pr_policy_test.rego                         100.0%
tests/opa/unit/global/license_policy_test.rego                          100.0%
total:                                                                   79.5%

Summary:
Module                                     Coverage Statements
---------------------------------------- ---------- ----------
  tests/opa/unit/global                       79.5%         78
  tests/opa/unit/terraform/module             99.0%        871
  tests/opa/unit/terraform/module_types       96.4%         84
  tests/opa/unit/terraform/provider           96.6%         58
Total                                         97.3%       1091
```

### JSON Coverage Format

The JSON coverage report provides a machine-readable summary in the following format:

```json
{
  "modules": [
    {
      "name": "tests/opa/unit/global",
      "coverage": 79.5,
      "statements": 78
    },
    {
      "name": "tests/opa/unit/terraform/module",
      "coverage": 99.0,
      "statements": 871
    }
  ],
  "total": 97.3,
  "errors": 0
}
```

### Raw Coverage Files

Raw coverage data is saved in the `tmp/coverage` directory with filenames based on the test path:

- Text format: `rego-coverage-tests-opa-unit-global.txt`
- JSON format: `rego-coverage-tests-opa-unit-global.json`

## Requirements

- OPA CLI must be installed and available in the PATH
- Go 1.16 or later
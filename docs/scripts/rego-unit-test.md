# Rego Unit Test

The `rego-unit-test` script runs unit tests for Open Policy Agent (OPA) Rego policies in the repository and generates coverage reports.

## Overview

This script automates the process of running Rego unit tests across multiple policy directories. It:

1. Reads test and policy directory mappings from the configuration file
2. Executes OPA tests for each test directory
3. Collects and processes coverage data
4. Generates human-readable or machine-readable coverage reports

## Usage

### Command Line

```bash
go run scripts/rego-unit-test/main.go [flags] /path/to/monorepo-config.json
```

### Flags

| Flag | Description |
|------|-------------|
| `--no-coverage` | Run tests without collecting coverage data |
| `--coverage-text` | Generate a human-readable text coverage report |
| `--coverage-json` | Generate a machine-readable JSON coverage report |
| `--data-path` | Path to the repository root (default: current directory) |

### Makefile Integration

The script is integrated into the repository's Makefile with the following targets:

```bash
# Run tests without coverage
make rego-unit-test

# Run tests with text coverage
make rego-unit-test-coverage

# Run tests with JSON coverage
make rego-unit-test-coverage-json

# Check Rego files for linting issues
make rego-lint

# Fix Rego formatting issues
make rego-format
```

## Configuration

The script reads test paths and policy mappings from the `monorepo-config.json` file:

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

## Coverage Reports

### Text Format

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

### JSON Format

The JSON coverage report provides a machine-readable summary:

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

## Integration with CI/CD

This script is used in the CI/CD pipeline to:

1. Validate that OPA policies have adequate test coverage
2. Ensure that policy changes don't break existing functionality
3. Generate coverage reports for quality metrics

The non-terraform-validation.yml workflow runs the following Rego-related tasks:

```yaml
- name: Run rego linting
  run: make rego-lint

- name: Run rego formatting
  run: make rego-format

- name: Run rego Unit Tests
  run: make rego-unit-test

- name: Run rego Test Coverage
  run: make rego-unit-test-coverage

- name: Check Rego Test Coverage Threshold
  run: |
    echo "Running coverage check..."
    COVERAGE_JSON=$(make rego-unit-test-coverage-json 2>/dev/null)
    COVERAGE=$(echo "$COVERAGE_JSON" | grep -o '"total": [0-9.]*' | awk '{print $2}')
    THRESHOLD=95
    
    if (( $(echo "$COVERAGE >= $THRESHOLD" | bc -l) )); then
      echo -e "\033[32mPASS: Coverage is $COVERAGE% (threshold: $THRESHOLD%)\033[0m"
      exit 0
    else
      echo -e "\033[31mFAIL: Coverage is $COVERAGE% (threshold: $THRESHOLD%)\033[0m"
      exit 1
    fi
```

This ensures that all Rego code is properly formatted, passes linting checks, and maintains a high test coverage threshold of 95%.

## Requirements

- OPA CLI must be installed and available in the PATH
- Go 1.16 or later

## Source Code

The script is located at `scripts/rego-unit-test/main.go`.
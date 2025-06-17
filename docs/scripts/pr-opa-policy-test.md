# PR OPA Policy Test Script

This document describes the script used to evaluate pull requests against Open Policy Agent (OPA) policies in the monorepo.

## Overview

The `pr-opa-policy-test` script validates pull requests against a set of OPA policies to enforce the monorepo's governance rules. It ensures that PRs adhere to standards such as the single module policy, separation policy, and empty PR policy.

## Features

- Evaluates PRs against OPA policies
- Provides detailed error messages for policy violations
- Uses color-coded output for better readability
- Supports testing with simulated changed files
- Integrates with the monorepo's configuration system
- Compares feature branch changes against primary branch

## Usage

The script can be used to validate changes between branches:

```bash
go run scripts/pr-opa-policy-test/main.go \
  --config monorepo-config.json \
  --policy-dirs policies/opa/global \
  --feature-branch feature-branch \
  --primary-branch main
```

Or using the Makefile:

```bash
POLICY_DIRS=./policies/opa/global make pr-opa-policy-test FEATURE_BRANCH=feature-branch PRIMARY_BRANCH=main
```

## Command Line Options

- `--config`: Path to the monorepo configuration file (required)
- `--policy-dirs`: Comma-separated list of directories containing OPA policy files (required)
- `--feature-branch`: Feature branch commit or reference (required)
- `--primary-branch`: Primary branch to merge into (defaults to "main")

## Configuration

The script uses the following sections from the `monorepo-config.json` file:

- `test_changed_files`: (Optional) List of files to use for testing instead of git changes

The script can also be configured through the Makefile with the following parameters:

- `FEATURE_BRANCH`: The feature branch to compare (required)
- `PRIMARY_BRANCH`: The primary branch to merge into (defaults to "main")
- `POLICY_DIRS`: Comma-separated list of directories containing OPA policy files (required)

The script can also be configured through the Makefile with the following parameters:

- `FEATURE_BRANCH`: The feature branch to compare (required)
- `PRIMARY_BRANCH`: The primary branch to merge into (defaults to "main")
- `POLICY_DIRS`: Comma-separated list of directories containing OPA policy files (required)

## Policy Evaluation

The script evaluates the PR against all `.rego` files in the specified policy directory. Each policy can define violations with the following structure:

```rego
violation[result] {
  # Policy logic
  result := {
    "policy": "policy_name",
    "severity": "error",
    "message": "Human-readable error message",
    "details": "Technical details about the violation",
    "resolution": "Steps to resolve the violation"
  }
}
```

## Input Structure

The script creates the following input structure for OPA policies:

```json
{
  "changed_files": ["path/to/file1", "path/to/file2"],
  "config": {
    // Contents of monorepo-config.json
  }
}
```

## Output

The script produces detailed output about policy violations:

```
=== Evaluating PR policies ===
Evaluating policy: single_module_policy.rego
✗ Policy violations found in single_module_policy.rego
  Multiple modules detected in the same PR
  Details: Found changes to modules: providers/aws/primitives/s3-bucket, providers/aws/primitives/dynamodb-table
  Resolution: Split your changes into separate PRs, one for each module

=== Policy check failed ===
```

## Error Handling

The script exits with a non-zero status code in the following cases:

1. Required command line arguments are missing
2. The configuration file cannot be read or parsed
3. OPA evaluation fails
4. Any policy violations are detected

Each error is clearly reported with details and resolution steps.

## Implementation Details

The script works by:

1. Loading the monorepo configuration
2. Getting the list of changed files (from the configuration or git)
3. Creating the input structure for OPA
4. Running OPA evaluation for each policy file
5. Reporting any violations
6. Exiting with the appropriate status code

### Changed Files Detection

The script gets the list of changed files by comparing the feature branch with the primary branch. It finds the common ancestor (merge-base) of the two branches and then identifies all files that would be changed when merging the feature branch into the primary branch. For testing purposes, it can also use a list of files specified in the configuration.

## Integration with CI/CD

This script is typically used as one of the first steps in the PR validation workflow to ensure that the PR adheres to the monorepo's governance rules before proceeding with more specific validations.
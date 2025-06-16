# Detect Proposed Git Repo Changes Script

This document describes the script used to detect and validate changes in pull requests for the Terraform modules monorepo.

## Overview

The `detect-proposed-git-repo-changes` script analyzes the files changed in a pull request to enforce the monorepo's governance policies:

1. Single Module Policy: PRs must change only one Terraform module at a time
2. Separation Policy: PRs must either modify exactly one module OR only non-module files (not both)

## Features

- Detects which files have been changed in a pull request
- Identifies which Terraform module(s) the changes belong to
- Validates that changes comply with the monorepo's governance policies
- Outputs module path and type for further validation steps in CI/CD pipelines
- Provides clear error messages when policy violations are detected

## Usage

The script is primarily used in CI/CD pipelines to validate pull requests:

```bash
go run scripts/detect-proposed-git-repo-changes/main.go --config monorepo-config.json
```

## Command Line Options

- `--config`: Path to the monorepo configuration file (required)

## Configuration

The script uses the following sections from the `monorepo-config.json` file:

- `module_roots`: List of root directories for modules
- `module_types`: Configuration for each module type, including path patterns
- `test_changed_files`: (Optional) List of files to use for testing instead of git changes

## Output

The script outputs environment variables that can be used by subsequent CI/CD steps:

- `MODULE_PATH`: Path to the module being modified (if a single module is detected)
- `MODULE_TYPE`: Type of the module being modified (if a single module is detected)
- `IS_MODULE`: Boolean indicating whether the changes are to a module (`true`) or non-module files (`false`)

In GitHub Actions, these are also set as outputs using the `::set-output` syntax.

## Error Handling

The script exits with a non-zero status code in the following cases:

1. Multiple modules are detected in the same PR
2. Both module and non-module changes are detected in the same PR
3. Required configuration is missing or invalid

Error messages clearly explain the policy violation and list the affected files or modules.

## Implementation Details

The script works by:

1. Loading the monorepo configuration
2. Getting the list of changed files
3. Checking each file against module path patterns to determine which module(s) it belongs to
4. Identifying non-module files
5. Validating that changes comply with the governance policies
6. Outputting the results

## Integration with CI/CD

This script is typically used as the first step in the PR validation workflow to determine:

1. Whether the PR contains module changes or non-module changes
2. Which specific module is being modified (if applicable)
3. What type of module is being modified (if applicable)

Based on this information, subsequent steps in the workflow can run the appropriate validation checks.
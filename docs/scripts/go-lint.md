# Go Lint Script

This document describes the script used to perform code quality checks on Go code in the Terraform modules monorepo.

## Overview

The `go-lint` script runs code quality checks on all Go code in the repository, ensuring consistent formatting and correctness. It enforces the repository's code quality standards by running `gofmt` and `go vet` on all Go files.

## Features

- Runs `gofmt` to check code formatting
- Runs `go vet` to check for common coding mistakes
- Supports ignoring specific directories
- Provides clear pass/fail status for each check
- Loads ASDF environment to ensure consistent tool versions

## Usage

The script is primarily used through the following make task:

```bash
# Run all linting checks
make go-lint
```

## Command Line Options

- `--config`: Path to config JSON file (required when --path is not specified)
- `--path`: Direct path to lint (bypasses config)
- `--skip-prefix`: Package prefix to skip during linting

## Usage Modes

The script supports two modes of operation:

1. **Config Mode** (default): Uses monorepo-config.json to determine directories to lint
   ```bash
   go run ./scripts/go-lint/main.go --config ./monorepo-config.json
   ```

2. **Direct Path Mode**: Lints a specific directory directly
   ```bash
   go run ./scripts/go-lint/main.go --path tests
   ```

## Output

The script produces a detailed report of linting issues:

```
Step 1: Running gofmt checks...
✅ All files properly formatted

Step 2: Running go vet checks...
✅ github.com/terraform-modules/scripts/go-unit-test
✅ github.com/terraform-modules/scripts/install-tools
❌ github.com/terraform-modules/scripts/lint (violates go vet policy)
   scripts/lint/main.go:42:14: undefined: failedFiles

=== Lint Summary ===
gofmt checks: PASS ✅
go vet checks: FAIL ❌ (violates code correctness policy)
```

## Error Handling

The script exits with a non-zero status code if any of the following occur:

1. `gofmt` finds formatting issues in any Go file
2. `go vet` finds potential bugs or issues in any Go file or package

Each error is clearly reported with the file path and specific issue.

## Implementation Details

The script is implemented in Go and follows these steps:

1. Parse command line flags for ignore patterns and skip prefixes
2. Load the ASDF environment to ensure consistent tool versions
3. Run `gofmt -l .` to check for formatting issues
4. Run `go list ./...` to get all Go packages
5. Run `go vet` on each package
6. Run `go vet` on individual Go files in the scripts directory
7. Summarize the results and exit with the appropriate status code

### Directory Traversal

The script handles two types of Go code:

1. Standard Go packages (checked using `go list ./...` and `go vet`)
2. Individual Go files in the scripts directory (checked using file traversal and `go vet`)

This ensures that all Go code is checked, even if it's not part of a proper Go package.

## Performance Optimization

The script sets `GOGC=off` to disable garbage collection during linting, which can improve performance for short-lived processes like linting tools.

## Integration with CI/CD

This script is typically used in the CI/CD pipeline to ensure code quality standards are maintained. It's part of the `non-terraform-validation.yml` workflow that runs on pull requests containing non-Terraform changes.
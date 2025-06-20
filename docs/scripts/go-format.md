# Go Format Script

This document describes the script used to format Go code in the Terraform modules monorepo.

## Overview

The `go-format` script automatically formats Go code using `gofmt`, ensuring consistent code formatting across the repository. It can operate in two modes: config-driven for repository-wide formatting, or direct path mode for specific directories.

## Features

- Runs `gofmt` to format Go code
- Supports both config-driven and direct path modes
- Provides clear feedback on files that were formatted
- Exits with error code if formatting fails

## Usage

The script is primarily used through the following make tasks:

```bash
# Run repository-wide formatting
make go-format

# Run formatting on module tests (from within a module directory)
make go-format
```

## Command Line Options

- `--config`: Path to config JSON file (required when --path is not specified)
- `--path`: Direct path to format (bypasses config)

## Usage Modes

The script supports two modes of operation:

1. **Config Mode** (default): Uses monorepo-config.json to determine directories to format
   ```bash
   go run ./scripts/go-format/main.go --config ./monorepo-config.json
   ```

2. **Direct Path Mode**: Formats a specific directory directly
   ```bash
   go run ./scripts/go-format/main.go --path tests
   ```

## Output

The script produces a report of formatting actions:

```
Formatting Go code...
✅ All files in scripts/go-lint already properly formatted
Fixed: tests/common/module_test.go
✅ Formatting complete: fixed 1 file(s)
```

## Error Handling

The script exits with a non-zero status code if any formatting operation fails. Each error is clearly reported with the file path and specific issue.

## Integration with CI/CD

This script is used in the CI/CD pipeline to ensure code formatting standards are maintained. It's part of the Terraform module validation workflow that runs on pull requests.
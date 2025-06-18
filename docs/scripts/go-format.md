# Go Format Script

The `go-format` script is a utility for automatically formatting Go code in the repository according to Go's standard formatting rules.

## Overview

This script:
- Recursively finds all Go files in the repository
- Uses `gofmt` to format each file that needs formatting
- Skips specified directories (via the `--ignore` flag)
- Only reports files that were actually modified

## Usage

The script is typically used through the `make` command:

```bash
# Format all Go files in the repository
make go-format

# Format Go files in a specific module
cd path/to/module && make go-format
```

## Command Line Options

| Option | Description |
|--------|-------------|
| `--ignore=DIR1,DIR2,...` | Comma-separated list of directories to ignore during formatting |

## Implementation Details

The script:
1. Uses `gofmt -l .` to identify files that need formatting
2. Applies `gofmt -w` to each file that needs formatting
3. Reports only the files that were actually modified
4. Skips files in ignored directories

## Integration with CI/CD

The `go-format` script is used in the CI/CD pipeline to ensure that all Go code follows consistent formatting standards. It's typically run before the `go-lint` check to fix formatting issues automatically.

## Example Output

```
Fixing code formatting and lint issues...
Building format tool...
⚠️  Ignoring directory during formatting: bin
Formatting Go code...
Fixed: scripts/detect-proposed-git-repo-changes/main.go
Fixed: scripts/detect-proposed-git-repo-changes/main_test.go
Fixed: scripts/go-unit-test/main.go
Fixed: scripts/go-unit-test/main_test.go

✅ Formatting complete: fixed 4 file(s)
```

If all files are already properly formatted:

```
Fixing code formatting and lint issues...
Building format tool...
⚠️  Ignoring directory during formatting: bin
Formatting Go code...
✅ All files already properly formatted
```
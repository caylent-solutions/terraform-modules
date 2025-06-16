# Go Unit Test Script

This document describes the Go unit test script used for running tests and collecting coverage metrics for Go code in the monorepo.

## Overview

The `go-unit-test` script is a centralized tool for running Go unit tests across all Go packages in the monorepo. It provides consistent test execution, coverage reporting, and error handling.

## Features

- Run unit tests for all Go packages defined in the monorepo configuration
- Collect and report test coverage metrics
- Generate coverage reports in both text and JSON formats
- Properly handle and report test failures
- Support for running tests without collecting coverage
- CI enforcement of minimum 20% test coverage threshold

## Usage

The script is primarily used through the following make tasks:

```bash
# Run all Go unit tests without coverage
make go-unit-test

# Run all Go unit tests with coverage and output as text
make go-unit-test-coverage

# Run all Go unit tests with coverage and output as JSON
make go-unit-test-coverage-json
```

## Command Line Options

The script supports the following command line options:

- `--no-coverage`: Run tests without collecting coverage data
- `--coverage-text`: Output coverage as formatted text
- `--coverage-json`: Output coverage as JSON

## Configuration

The script uses the `coverage_groups` section in the `monorepo-config.json` file to determine which packages to test:

```json
"coverage_groups": [
  {
    "name": "Go Unit Test",
    "emoji": "🧪",
    "outputFile": "go-unit-test.out",
    "testPath": "./scripts/go-unit-test",
    "coverPkg": "./scripts/go-unit-test"
  },
  {
    "name": "Detect Module Changes",
    "emoji": "🔍",
    "outputFile": "detect-module-changes.out",
    "testPath": "./scripts/detect-module-changes",
    "coverPkg": "./scripts/detect-module-changes"
  }
]
```

Each entry in the `coverage_groups` array defines:

- `name`: Display name for the test group
- `emoji`: Emoji to display in console output
- `outputFile`: Name of the coverage output file
- `testPath`: Path to the directory containing the tests
- `coverPkg`: Package path for coverage collection

## Output Format

### Text Output

When run with the `--coverage-text` flag, the script produces a human-readable report:

```
📈 Running tests for Go Test Coverage JSON...

Coverage for Go Test Coverage JSON:
github.com/terraform-modules/scripts/go-test-coverage-json/main.go:48:  main                            0.0%
github.com/terraform-modules/scripts/go-test-coverage-json/main.go:205: runTest                         0.0%
github.com/terraform-modules/scripts/go-test-coverage-json/main.go:219: runTestWithCoverage             0.0%
github.com/terraform-modules/scripts/go-test-coverage-json/main.go:267: extractCoveragePercentage       100.0%
github.com/terraform-modules/scripts/go-test-coverage-json/main.go:283: parseCoveragePercentage         100.0%
github.com/terraform-modules/scripts/go-test-coverage-json/main.go:291: extractStatementCount           100.0%
github.com/terraform-modules/scripts/go-test-coverage-json/main.go:304: fileExists                      0.0%
github.com/terraform-modules/scripts/go-test-coverage-json/main.go:309: countLinesInFile                0.0%
total:                                                                  (statements)                    14.1%

Summary:
Module                                   Coverage   Statements
---------------------------------------- ---------- ----------
  Go Test Coverage JSON                       14.1%         72
  Detect Module Changes                       52.0%         47
  Install Tools                               12.2%         56
  Module Type Validator                       50.0%         30
  Module Validator                            14.4%         55
  PR OPA Policy Test                          19.7%         39
  Terraform File Collector                    35.0%         25
  Lint                                        12.1%         64
---------------------------------------- ---------- ----------
Total                                         22.8%        388
```

### JSON Output

When run with the `--coverage-json` flag, the script produces a machine-readable JSON report:

```json
{
  "modules": [
    {
      "name": "Go Unit Test",
      "coverage": 15.3,
      "statements": 73
    },
    {
      "name": "Detect Module Changes",
      "coverage": 52,
      "statements": 47
    }
  ],
  "total": 23.121921182266007,
  "errors": 0
}
```

## Error Handling

The script properly handles and reports test failures:

- Test failures are reported in the console output
- Failed tests are marked with a ❌ emoji
- The script exits with a non-zero status code if any tests fail
- In JSON output, errors are included in the `errors` field and individual module results

## Coverage Threshold

The CI pipeline enforces a minimum test coverage threshold of 20% for all Go code:

- The `non-terraform-validation.yml` workflow includes a step that checks if the total coverage is at least 20%
- If coverage is below the threshold, the workflow will fail with a clear error message
- Coverage percentage is extracted from the JSON output of `make go-unit-test-coverage-json`
- The threshold check displays a green "PASS" message when coverage meets or exceeds 20%
- The threshold check displays a red "FAIL" message when coverage is below 20%

## Implementation Details

The script is implemented in Go and follows these steps:

1. Parse command line flags and arguments
2. Load the monorepo configuration file
3. For each coverage group:
   - Run the tests with or without coverage
   - Collect and parse the coverage data
   - Report any errors
4. Calculate the weighted average coverage
5. Output the results in the requested format
6. Exit with the appropriate status code

## Adding New Test Groups

To add a new test group:

1. Add a new entry to the `coverage_groups` section in `monorepo-config.json`
2. Ensure the directory structure matches the expected pattern
3. Run the tests to verify they are picked up correctly
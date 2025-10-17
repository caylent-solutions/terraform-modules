# Common Tests

This directory contains common tests that validate the core functionality of the AWS Constants data module.

## Test Coverage

- **TestModuleOutputs**: Validates that all expected outputs are present and not nil
- **TestConstantValues**: Validates that specific constant values match expected AWS API values

## Purpose

These tests ensure that:
1. All outputs are properly defined and accessible
2. Constant values match AWS API specifications
3. The module provides consistent, reliable constants

## Future Enhancements

Future tests in this directory will include:
- API validation tests that query live AWS APIs to verify constant accuracy
- Comprehensive validation of all constant groups
- Performance tests for large constant sets

## Running Tests

```bash
# From the module root
make test-common

# Or directly with go test
cd tests/common
go test -v
```
# Basic Example Tests

This directory contains tests for the basic example of the AWS Constants data module.

## Test Coverage

- **TestBasicExample**: Validates that the basic example can be applied successfully
- **TestConstantsAccessibility**: Verifies that all constants are properly accessible through the module

## Purpose

These tests ensure that:
1. The module can be instantiated without errors
2. All constants are properly exposed and accessible
3. The basic usage pattern works as expected

## Running Tests

```bash
# From the module root
make test-basic

# Or directly with go test
cd tests/basic
go test -v
```
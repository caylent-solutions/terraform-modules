# AWS Constants Data Module Tests

This directory contains tests for the AWS Constants data module.

## Test Structure

- `basic/` - Tests for the basic example implementation
- `common/` - Common tests that validate core module functionality

## Test Strategy

The tests are designed to validate that:

1. **Constants are accessible** - All exported constants can be retrieved
2. **Values are correct** - Constants match expected AWS API values
3. **Future API validation** - Framework for validating constants against live AWS APIs

## Running Tests

From the module root directory:

```bash
# Run all tests
make test

# Run only basic tests
make test-basic

# Run only common tests  
make test-common
```

## Future Enhancements

Future test implementations will include:

- API validation tests that query AWS SSO Admin API to verify IAM Identity Center constants
- Pattern validation tests for regex patterns and format strings
- Comprehensive coverage of all constant groups
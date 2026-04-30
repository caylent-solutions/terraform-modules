# WAFv2 Web ACL Module Tests

This directory contains tests for the `waf-webacl` Terraform module using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Test Structure

- **basic/**: Tests for the basic example (regional WAFv2 Web ACL with default managed rule groups and rate-based rules)
- **advanced/**: Tests for the advanced example (IP set blocking, custom rate limits, and all optional features enabled)
- **common/**: Tests that run across all examples (terraform validate, required outputs present in all examples)
- **helpers/**: Shared assertion helpers used by all test packages (ARN format validation, output checks, state assertions)

## Running Tests

Tests require AWS credentials with WAFv2 permissions. Use the provided Makefile commands:

```bash
# Install Go dependencies
make install

# Run all tests
make test

# Lint Go test files
make go-lint

# Format Go test files
make go-format

# Clean up temporary files
make clean
```

## Test Requirements

- Go >= 1.24.4
- Terraform >= 1.12.1
- AWS credentials configured with WAFv2 permissions
- All Go test files must pass linting (`make go-lint`)
- All Go test files must be properly formatted (`make go-format`)

## Writing Tests

See [tests/basic/README.md](./basic/README.md) for information on the basic example tests and how to add new assertions.

Shared assertion helpers are available in [tests/helpers/helpers.go](./helpers/helpers.go). Import the package as `github.com/caylent-solutions/terraform-modules/providers/aws/primitives/waf-webacl/tests/helpers` and use the provided functions (`AssertWebACLArnFormat`, `AssertOutputNotEmpty`, `AssertOutputEmpty`, `AssertResourceCountExact`, `AssertStateContains`) instead of duplicating inline assertions.

## WAFv2 Permissions Required

Tests create and destroy real AWS resources. The test IAM role must have permissions including:

- `wafv2:CreateWebACL`
- `wafv2:DeleteWebACL`
- `wafv2:GetWebACL`
- `wafv2:ListWebACLs`
- `wafv2:CreateIPSet`
- `wafv2:DeleteIPSet`
- `wafv2:GetIPSet`
- `wafv2:TagResource`
- `wafv2:ListTagsForResource`

# Common WAFv2 Web ACL Tests

This directory contains tests that run against all examples of the `waf-webacl` module to verify shared behaviour.

## Tests Included

- **TestTerraformValidateAllExamples**: Runs `terraform validate` on every example (basic, advanced)
- **TestWebACLArnPresentInAllExamples**: Verifies `web_acl_arn` is non-empty and matches the WAFv2 ARN format in every example
- **TestWebACLNamePresentInAllExamples**: Verifies `web_acl_name` is non-empty in every example

## Running Tests

```bash
# Run common tests specifically
go test ./tests/common -v

# Run all tests for the module
make test
```

## Requirements

- Go >= 1.24.4
- Terraform >= 1.12.1
- AWS credentials with WAFv2 permissions

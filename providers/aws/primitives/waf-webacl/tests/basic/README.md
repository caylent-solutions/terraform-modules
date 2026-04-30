# Basic WAFv2 Web ACL Tests

This directory contains tests specific to the `basic` example of the `waf-webacl` module.

## Tests Included

- **TestBasicWebACLCreation**: Verifies the Web ACL is created and its ARN follows the expected AWS WAFv2 format
- **TestBasicWebACLName**: Verifies the `web_acl_name` output matches the configured value
- **TestBasicWebACLCapacity**: Verifies WAF capacity units are reported as a non-negative integer
- **TestBasicWebACLResourceCount**: Asserts exactly one `aws_wafv2_web_acl.this` in state; asserts no IP set (disabled by default)
- **TestBasicWebACLRequiredOutputs**: Verifies all expected outputs are defined
- **TestBasicWebACLIdempotency**: Applies the same config twice and confirms no drift
- **TestBasicWebACLTerraformValidate**: Runs `terraform validate` against the basic example
- **TestBasicWebACLArnFormat**: Verifies the ARN matches the full `arn:aws:wafv2:...:regional/webacl/<name>/<id>` pattern
- **TestBasicWebACLNoAssociation**: Confirms no `aws_wafv2_web_acl_association` or `aws_wafv2_web_acl_logging_configuration` resources are created (both disabled in the basic example)
- **TestBasicWebACLStateContainsWebACL**: Confirms `module.waf_webacl.aws_wafv2_web_acl.this` exists in Terraform state

## Key Features Tested

- WAFv2 regional Web ACL creation with managed rule groups enabled by default
- Per-IP rate-based rule and X-Caylent-Tool header rate-based rule
- No IP set, no logging, no resource association in the basic example
- Output format and ARN structure validation
- Idempotency guarantee

## Running Tests

```bash
# Run all basic tests
go test ./tests/basic -v

# Run all tests for the module
make test
```

## Requirements

- Go >= 1.24.4
- Terraform >= 1.12.1
- AWS credentials with WAFv2 permissions

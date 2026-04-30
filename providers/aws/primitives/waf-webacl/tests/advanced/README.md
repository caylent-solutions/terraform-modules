# Advanced WAFv2 Web ACL Tests

This directory contains tests specific to the `advanced` example of the `waf-webacl` module.

## Tests Included

- **TestAdvancedWebACLCreation**: Verifies the Web ACL is created and ARN format is correct
- **TestAdvancedWebACLIPSetEnabled**: Verifies the IP set is created with a valid ARN when `enable_ip_set_rule = true`
- **TestAdvancedWebACLResourceCount**: Confirms exactly one Web ACL and at least one IP set exist in state
- **TestAdvancedWebACLIdempotency**: Applies the same config twice and confirms no drift

## Key Features Tested

- WAFv2 Web ACL creation with IP set blocking enabled
- IP set ARN format validation
- Resource count verification (Web ACL + IP set)
- Idempotency guarantee

## Running Tests

```bash
# Run advanced tests specifically
go test ./tests/advanced -v

# Run all tests for the module
make test
```

## Requirements

- Go >= 1.24.4
- Terraform >= 1.12.1
- AWS credentials with WAFv2 permissions

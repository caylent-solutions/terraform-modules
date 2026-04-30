# Test Helpers

This directory contains shared helper functions used across route53-record Terratest suites.

## Functions

- `AssertRoute53RecordExists` -- verifies record outputs are non-empty
- `AssertRecordType` -- verifies the record type output matches expected value
- `AssertRecordTTL` -- verifies the record TTL output matches expected value
- `AssertOutputNotEmpty` -- asserts a Terraform output is not empty
- `AssertOutputEmpty` -- asserts a Terraform output is empty
- `AssertOutputMatchesRegex` -- asserts an output matches a regex pattern
- `AssertOutputEquals` -- asserts an output matches an expected value
- `AssertOutputExists` -- asserts an output key exists
- `AssertResourceCountExact` -- asserts an exact count of a resource type in state
- `AssertStateContains` -- asserts a specific resource path is in the state
- `GenerateUniqueName` -- generates a unique name string with a timestamp suffix
- `GetRequiredTerraformVersion` -- reads the required Terraform version from versions.tf

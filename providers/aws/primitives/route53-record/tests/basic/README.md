# Basic Route53 Record Tests

This directory contains Terratest tests for the basic Route53 record example.

## Tests

- `TestBasicRoute53RecordConfiguration` -- verifies that a record is created with the expected outputs
- `TestBasicRoute53RecordFQDN` -- verifies that the FQDN output matches the expected DNS format
- `TestBasicRoute53RecordType` -- verifies the record type output is correct
- `TestBasicRoute53RecordResourceCounts` -- verifies exactly one Route53 record resource is created
- `TestBasicRoute53RecordIdempotency` -- verifies that applying twice produces no changes
- `TestBasicRoute53RecordStateContains` -- verifies the record resource appears in Terraform state

## Running Tests

```bash
# From the module root
make test

# Or directly
cd tests/basic
go test -v -timeout 30m ./...
```

## Requirements

- Go >= 1.24
- Terraform >= 1.12.1
- AWS credentials configured with permission to manage Route53

# Module Tests

Terratest fixtures for the `dynamodb-table` primitive module, using the
[Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

## Test Structure

- **basic/** -- Terratest for the `examples/basic/` example, asserting
  table creation, key schema, GSI, streams, TTL, PITR, and SSE.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/dynamodb-table
```

Configuration is read from `../test.config` (`TERRATEST_IDEMPOTENCY=true`,
`GO_TEST_TIMEOUT=120m`). Tests run against the AWS account configured in
the workspace (`aws sts get-caller-identity`).

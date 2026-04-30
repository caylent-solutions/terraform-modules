# Basic Example Tests

Terratest fixtures for the `examples/basic/` example of the
`dynamodb-table` primitive module.

## What is asserted

- `TableExists` -- the table ARN, name, and ARN format match what the
  module produced.
- `DescribeTableMatchesInputs` -- AWS-side billing mode, key schema
  (`pk` HASH + `sk` RANGE), and exactly one GSI named `gsi1`.
- `StreamEnabled` -- DynamoDB Streams are enabled with the expected
  view type and the `stream_arn` output is non-empty.
- `TtlEnabled` -- TimeToLive is `ENABLED` on the `expires_at`
  attribute.
- `PointInTimeRecoveryEnabled` -- PITR continuous backups are
  `ENABLED`.
- `ServerSideEncryptionAlwaysOn` -- SSE description shows `ENABLED`
  status.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/dynamodb-table
```

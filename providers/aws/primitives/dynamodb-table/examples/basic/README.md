# dynamodb-table / basic example

Provisions a single DynamoDB table with a partition + sort key, one
GSI, DynamoDB Streams, TTL, and PITR enabled.

## What it creates

- `module.table` -- the `dynamodb-table` primitive, configured with:
  - `name = "<var.table_name>-<random>"`
  - `billing_mode = PAY_PER_REQUEST`
  - `hash_key = pk`, `range_key = sk`
  - GSI `gsi1` on `gsi1pk` with `projection_type = ALL`
  - Streams enabled (`NEW_AND_OLD_IMAGES`)
  - TTL on `expires_at`
  - PITR enabled, deletion protection off (test isolation)

## Apply

```bash
cd providers/aws/primitives/dynamodb-table/examples/basic
terraform init
terraform apply -auto-approve
```

## Outputs

- `table_arn` -- ARN of the table
- `table_name` -- final table name (with random suffix)
- `stream_arn` -- DynamoDB Streams ARN

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

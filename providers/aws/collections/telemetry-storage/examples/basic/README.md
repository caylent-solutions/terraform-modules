# telemetry-storage / basic example

Provisions the `telemetry-storage` collection with PAY_PER_REQUEST defaults:

- An SQS ingest queue with the redrive policy wired at an auto-managed
  dead-letter queue (`queue_create_dlq` defaults to true)
- A DynamoDB table with `pk`/`sk` composite key plus one global
  secondary index (`gsi1`) covering `gsi1pk`/`gsi1sk`
- An EventBridge bus with no rules / targets

## Apply

```bash
cd providers/aws/collections/telemetry-storage/examples/basic
terraform init
terraform apply -auto-approve
```

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

# telemetry-storage

AWS collection module composing the three primitives that make up the Caylent
telemetry storage tier:

- `sqs-queue` -- ingest queue plus an auto-managed dead-letter queue
  (the primitive's built-in DLQ support; the collection does not declare
  a second sqs-queue module). The redrive policy is wired between the
  two queues by the primitive.
- `dynamodb-table` -- events table with caller-supplied schema and
  optional GSIs / LSIs / streams
- `eventbridge-bus` -- fan-out point for downstream consumers
  (OpenSearch indexer, Certinia stub, alerts -- consumers attach their
  own `rules` and `targets` via the pass-through input maps)

## Usage

```hcl
module "telemetry_storage" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/collections/telemetry-storage?ref=providers/aws/collections/telemetry-storage/v0.1.0"

  queue_name = "telemetry-prod-ingest"

  table_name      = "telemetry-prod-events"
  table_hash_key  = "pk"
  table_range_key = "sk"
  table_attributes = [
    { name = "pk", type = "S" },
    { name = "sk", type = "S" },
  ]

  bus_name = "telemetry-prod-bus"
}
```

For a runnable example see [`examples/basic/`](examples/basic/README.md).

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

## Testing

```bash
make tf-test MODULE_PATH=providers/aws/collections/telemetry-storage
```

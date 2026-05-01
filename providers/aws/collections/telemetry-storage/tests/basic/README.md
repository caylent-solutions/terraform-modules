# Basic Example Tests

Terratest fixtures for `examples/basic/`. Asserted behavior:

- `OutputsPopulated` -- queue/dlq/table/bus arns and names match the
  expected prefixes and AWS service ARN shapes
- `RedrivePolicyWiredToDLQ` -- the primary queue's `RedrivePolicy`
  attribute references the DLQ ARN
- `DDBTableExistsWithGSI` -- `DescribeTable` returns the expected
  table name with one global secondary index `gsi1`
- `EventBridgeBusExists` -- `DescribeEventBus` returns the expected
  name and ARN

## Running

```bash
make tf-test MODULE_PATH=providers/aws/collections/telemetry-storage
```

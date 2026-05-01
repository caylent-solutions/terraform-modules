# Module Tests

Terratest fixtures for the `telemetry-storage` collection.

## Test Structure

- **basic/** -- Asserts that PAY_PER_REQUEST + DLQ-wired ingest queue
  + DDB table with one GSI + EventBridge bus all come up and the
  redrive policy is wired correctly.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/collections/telemetry-storage
```

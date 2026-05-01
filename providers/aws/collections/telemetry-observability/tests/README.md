# Module Tests

Terratest fixtures for the `telemetry-observability` collection.

## Test Structure

- **basic/** -- Asserts that an OpenSearch domain + Grafana workspace
  + indexer Lambda all come up and are discoverable via the AWS APIs.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/collections/telemetry-observability
```

Note: provisioning takes ~15-20 minutes per run because of the
OpenSearch domain and Grafana workspace creation latencies.

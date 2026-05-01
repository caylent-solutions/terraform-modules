# Module Tests

Terratest fixtures for the `opensearch-domain` primitive.

## Test Structure

- **basic/** -- Asserts domain existence, always-on encryption + HTTPS attributes, and application log publishing wiring.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/opensearch-domain
```

OpenSearch domain Terratest runs ~30+ minutes (creation + destruction).

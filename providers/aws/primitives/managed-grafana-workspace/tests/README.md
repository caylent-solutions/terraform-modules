# Module Tests

Terratest fixtures for the `managed-grafana-workspace` primitive.

## Test Structure

- **basic/** -- Asserts that a SERVICE_MANAGED workspace with SAML auth
  comes up with the configured data sources and notification
  destinations.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/managed-grafana-workspace
```

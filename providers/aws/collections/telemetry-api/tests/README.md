# Module Tests

Terratest fixtures for the `telemetry-api` collection.

## Test Structure

- **basic/** -- Asserts that a no-custom-domain telemetry-api comes up
  with WAF, REST API, deployment stage, and authorizer Lambda all
  populated and discoverable via the AWS APIs.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/collections/telemetry-api
```

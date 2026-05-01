# Module Tests

Terratest fixtures for the `eventbridge-bus` primitive.

## Test Structure

- **basic/** -- Asserts the bus exists with the right ARN, and that the rule + target are wired with the configured DLQ and retry policy.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/eventbridge-bus
```

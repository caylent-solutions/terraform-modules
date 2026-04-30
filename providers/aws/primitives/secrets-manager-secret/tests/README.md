# Module Tests

Terratest fixtures for the `secrets-manager-secret` primitive.

## Test Structure

- **basic/** -- Terratest for `examples/basic/`. Asserts secret existence, KMS key wiring, and that the initial secret value is retrievable as valid JSON.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/secrets-manager-secret
```

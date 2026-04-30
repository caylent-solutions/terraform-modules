# Module Tests

Terratest fixtures for the `appconfig-application` primitive module.

## Test Structure

- **basic/** -- Terratest for `examples/basic/`. Asserts application,
  environments, configuration profile (FeatureFlags type, hosted
  location), and deployment strategy parameters.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/appconfig-application
```

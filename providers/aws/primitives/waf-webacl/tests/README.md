# Module Tests

Terratest fixtures for the `waf-webacl` primitive module.

## Test Structure

- **basic/** -- Terratest for the `examples/basic/` example, asserting
  Web ACL creation, rule set composition, rate-based rule details,
  and WAF logging configuration.

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/waf-webacl
```

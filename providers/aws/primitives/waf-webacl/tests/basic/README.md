# Basic Example Tests

Terratest fixtures for `examples/basic/`. Asserted behavior:

- `WebAclExists` -- ARN, name, and log group ARN are populated
- `RuleSetMatchesInputs` -- 5 rules total (3 managed + 2 rate-based);
  per-IP rate rule has limit=2000 and IP aggregate; per-header rate
  rule has limit=1000, CUSTOM_KEYS aggregate, and the configured
  header name (`x-caylent-tool`)
- `LoggingConfigured` -- `GetLoggingConfiguration` returns the
  auto-managed log group ARN as the destination

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/waf-webacl
```

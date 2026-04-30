# waf-webacl

AWS WAFv2 Web ACL primitive Terraform module.

Ships:

- `aws_wafv2_web_acl` (REGIONAL or CLOUDFRONT scope) with configurable
  default action (`allow` or `block`)
- AWS Managed Rule Groups attached as variadic rules
  (`managed_rule_groups`); defaults include CommonRuleSet,
  KnownBadInputsRuleSet, and AmazonIpReputationList
- Per-IP rate-based rule (`rate_limit_per_ip`); 5-minute sliding window,
  blocks when the configured limit is exceeded for a given source IP
- Per-header rate-based rule with custom aggregate key
  (`rate_limit_per_header`); aggregates by a configurable header name
  (e.g. `x-caylent-tool`) lowercased before counting
- CloudWatch metrics + sampled-requests collection toggleable per Web ACL
- Optional WAF logging via `aws_wafv2_web_acl_logging_configuration`
  with the auto-managed CloudWatch Log Group (must be prefixed
  `aws-waf-logs-` per AWS WAF requirements; the module enforces that
  prefix) OR an externally provisioned destination ARN

Cross-variable validation enforces invariants at plan time:

- `logging_enabled = true` requires either `log_destination_arn` OR
  `create_log_group = true`.

## Usage

```hcl
module "webacl" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/waf-webacl?ref=providers/aws/primitives/waf-webacl/v0.1.0"

  name        = "telemetry-api"
  description = "WAF for the telemetry API stage"
  scope       = "REGIONAL"

  rate_limit_per_ip = {
    priority = 100
    limit    = 2000
  }

  rate_limit_per_header = {
    priority    = 110
    limit       = 1000
    header_name = "x-caylent-tool"
  }

  logging_enabled       = true
  create_log_group      = true
  log_retention_in_days = 30

  tags = {
    Application = "telemetry"
    Environment = "prod"
  }
}
```

For a runnable example see [`examples/basic/`](examples/basic/README.md).

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md) (auto-generated).

## Testing

```bash
make tf-test MODULE_PATH=providers/aws/primitives/waf-webacl
```

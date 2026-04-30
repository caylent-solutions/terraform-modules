# AWS WAFv2 Web ACL Terraform Module

A Terraform primitive module for creating and managing AWS WAFv2 regional Web ACLs with configurable managed rule groups, rate-based rules, IP set blocking, CloudWatch metrics, logging configuration, and resource association.

## Overview

This module provisions a regional AWS WAFv2 Web ACL suitable for protecting API Gateway endpoints, ALBs, AppSync APIs, and other regional resources. It ships pre-configured with the three AWS managed rule groups recommended for the Caylent telemetry platform (Core, KnownBadInputs, IPReputationList) and includes two rate-based rules: a per-IP rule and a custom aggregate rule keyed on the `X-Caylent-Tool` HTTP header.

## Key Features

- **AWS Managed Rule Groups**: AWSManagedRulesCommonRuleSet, AWSManagedRulesKnownBadInputsRuleSet, and AWSManagedRulesAmazonIpReputationList -- all enabled by default
- **Per-IP Rate Limiting**: Configurable request rate limit per IP address over a 5-minute window
- **Tool Header Rate Limiting**: Rate-based rule aggregated on the `X-Caylent-Tool` header for per-tool throttling
- **IP Set Blocking**: Optional block rule driven by a caller-supplied list of IPv4 CIDRs
- **CloudWatch Metrics**: Sampled request metrics enabled by default on all rules and the WebACL itself
- **WAF Logging**: Optional logging to a Kinesis Firehose or S3 destination
- **Resource Association**: Associates the WebACL with one or more regional resources via ARN list
- **Comprehensive Tagging**: Automatic `ManagedBy` and `Module` tags merged with caller-supplied tags

## Quick Start

### Minimal Web ACL (default rules)

```hcl
module "waf_webacl" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/waf-webacl?ref=providers/aws/primitives/waf-webacl/v{X.Y.Z}"

  name = "telemetry-api-waf"

  tags = {
    Environment = "production"
    Project     = "caylent-telemetry"
  }
}
```

### Web ACL with API Gateway association and custom rate limits

```hcl
module "waf_webacl" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/waf-webacl?ref=providers/aws/primitives/waf-webacl/v{X.Y.Z}"

  name                    = "telemetry-api-waf"
  rate_based_rule_limit   = 5000
  tool_header_rate_rule_limit = 500
  resource_arns           = [aws_api_gateway_stage.telemetry.arn]

  tags = {
    Environment = "production"
    Project     = "caylent-telemetry"
  }
}
```

### Web ACL with IP blocking and logging

```hcl
module "waf_webacl" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/waf-webacl?ref=providers/aws/primitives/waf-webacl/v{X.Y.Z}"

  name                = "telemetry-api-waf"
  enable_ip_set_rule  = true
  ip_set_addresses    = ["192.0.2.0/24", "198.51.100.0/24"]
  enable_logging      = true
  logging_destination_arns = [aws_kinesis_firehose_delivery_stream.waf_logs.arn]

  tags = {
    Environment = "production"
    Project     = "caylent-telemetry"
  }
}
```

## Module Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | required | Friendly name of the WebACL |
| `description` | `string` | `null` | Friendly description of the WebACL |
| `tags` | `map(string)` | `{}` | Tags to assign to all resources |
| `enable_rate_based_rule` | `bool` | `true` | Enable per-IP rate-based rule |
| `rate_based_rule_limit` | `number` | `2000` | Per-IP rate limit per 5-minute window |
| `enable_tool_header_rate_rule` | `bool` | `true` | Enable X-Caylent-Tool header rate rule |
| `tool_header_rate_rule_limit` | `number` | `1000` | Tool-header rate limit per 5-minute window |
| `enable_ip_set_rule` | `bool` | `false` | Enable IP set block rule |
| `ip_set_addresses` | `list(string)` | `[]` | IPv4 CIDRs to block |
| `enable_core_rule_set` | `bool` | `true` | Enable AWSManagedRulesCommonRuleSet |
| `enable_known_bad_inputs_rule_set` | `bool` | `true` | Enable AWSManagedRulesKnownBadInputsRuleSet |
| `enable_ip_reputation_rule_set` | `bool` | `true` | Enable AWSManagedRulesAmazonIpReputationList |
| `cloudwatch_metrics_enabled` | `bool` | `true` | Enable CloudWatch metrics |
| `sampled_requests_enabled` | `bool` | `true` | Enable sampled request storage |
| `enable_logging` | `bool` | `false` | Enable WAF logging |
| `logging_destination_arns` | `list(string)` | `[]` | Logging destination ARNs |
| `resource_arns` | `list(string)` | `[]` | Resource ARNs to associate with the WebACL |

See `TERRAFORM-DOCS.md` for the complete variable reference including all optional variables.

## Module Outputs

| Name | Description |
|------|-------------|
| `web_acl_id` | The ID of the WAFv2 Web ACL |
| `web_acl_arn` | The ARN of the WAFv2 Web ACL |
| `web_acl_name` | The name of the WAFv2 Web ACL |
| `web_acl_capacity` | Web ACL capacity units (WCUs) currently consumed |
| `web_acl_tags_all` | All tags assigned to the Web ACL |
| `ip_set_id` | The ID of the IP block set (null when disabled) |
| `ip_set_arn` | The ARN of the IP block set (null when disabled) |

## Examples

- [Basic](./examples/basic/) -- Minimal configuration using default managed rule groups and rate-based rules
- [Advanced](./examples/advanced/) -- Full configuration with IP set blocking, custom rate limits, and all optional features enabled

## Testing

Tests are written using the [Terraform Terratest Framework](https://github.com/caylent-solutions/terraform-terratest-framework).

```bash
# Install dependencies
make install

# Run all tests
make test
```

See [tests/README.md](./tests/README.md) for full test documentation.

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.12.1 |
| AWS Provider | ~> 6.0.0 |

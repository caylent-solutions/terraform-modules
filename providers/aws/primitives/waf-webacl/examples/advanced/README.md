# Advanced WAFv2 Web ACL Example

This example demonstrates advanced usage of the `waf-webacl` module with IP set blocking enabled alongside the default managed rule groups and rate-based rules.

## What This Example Creates

- A regional WAFv2 Web ACL named `telemetry-api-waf-advanced`
- Per-IP rate-based rule (5,000 requests per 5-minute window)
- X-Caylent-Tool header rate-based rule (500 requests per 5-minute window)
- IP set block rule (blocking 192.0.2.0/24)
- AWSManagedRulesCommonRuleSet (Core rule group)
- AWSManagedRulesKnownBadInputsRuleSet
- AWSManagedRulesAmazonIpReputationList
- CloudWatch metrics and sampled requests enabled on all rules

## Usage

```hcl
module "waf_webacl" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/waf-webacl?ref=providers/aws/primitives/waf-webacl/v{X.Y.Z}"

  name                    = "telemetry-api-waf-advanced"
  enable_ip_set_rule      = true
  ip_set_addresses        = ["192.0.2.0/24"]
  rate_based_rule_limit   = 5000
  tool_header_rate_rule_limit = 500

  tags = {
    Environment = "test"
    Purpose     = "waf-webacl-module-testing"
    Owner       = "terraform"
  }
}
```

## Requirements

- Terraform >= 1.12.1
- AWS Provider ~> 6.0.0

## Inputs

Refer to [TERRAFORM-DOCS.md](./TERRAFORM-DOCS.md) for all inputs and outputs.

## Testing

This example is tested as part of the module's test suite. To run tests for this example:

```bash
cd ../../
make test
```

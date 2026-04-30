# Basic WAFv2 Web ACL Example

This directory contains a basic example of the `waf-webacl` Terraform module. It creates a regional WAFv2 Web ACL with the default set of AWS managed rule groups, per-IP rate limiting, and X-Caylent-Tool header rate limiting.

## What This Example Creates

- A regional WAFv2 Web ACL named `telemetry-api-waf-basic`
- Per-IP rate-based rule (2,000 requests per 5-minute window)
- X-Caylent-Tool header rate-based rule (1,000 requests per 5-minute window)
- AWSManagedRulesCommonRuleSet (Core rule group)
- AWSManagedRulesKnownBadInputsRuleSet
- AWSManagedRulesAmazonIpReputationList
- CloudWatch metrics and sampled requests enabled on all rules

## Usage

```hcl
module "waf_webacl" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/waf-webacl?ref=providers/aws/primitives/waf-webacl/v{X.Y.Z}"

  name = "telemetry-api-waf-basic"

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

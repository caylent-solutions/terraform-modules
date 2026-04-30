# waf-webacl / basic example

Provisions a REGIONAL WAFv2 Web ACL with the three default AWS Managed
Rule Groups (Common, KnownBadInputs, IpReputation), a per-IP rate-based
rule, a per-header (custom-aggregate) rate-based rule, and WAF logging
to a CloudWatch Log Group.

## What it creates

- `module.webacl` -- the `waf-webacl` primitive, configured with:
  - Default action `allow`
  - Three managed rule groups (priorities 10/20/30)
  - Per-IP rate limit of 2000 / 5min (priority 100)
  - Per-`x-caylent-tool` header rate limit of 1000 / 5min (priority 110)
  - WAF logging enabled to a `aws-waf-logs-test-waf-webacl-<random>`
    CloudWatch Log Group (7-day retention)

## Apply

```bash
cd providers/aws/primitives/waf-webacl/examples/basic
terraform init
terraform apply -auto-approve
```

## Outputs

- `web_acl_arn`, `web_acl_name`, `web_acl_capacity`
- `log_group_arn`

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

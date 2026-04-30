## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.82.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.82.0, < 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.waf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_logging_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_metrics_enabled"></a> [cloudwatch\_metrics\_enabled](#input\_cloudwatch\_metrics\_enabled) | Enable CloudWatch metrics for the Web ACL and each rule. | `bool` | `true` | no |
| <a name="input_create_log_group"></a> [create\_log\_group](#input\_create\_log\_group) | Create a CloudWatch Log Group for WAF logs. The group name must start with `aws-waf-logs-` per AWS WAF requirements; the module enforces that prefix. | `bool` | `true` | no |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | Default action for requests that match no rules. `allow` (most common; rules are explicit blocks) or `block` (deny-by-default). | `string` | `"allow"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Web ACL. | `string` | `null` | no |
| <a name="input_log_destination_arn"></a> [log\_destination\_arn](#input\_log\_destination\_arn) | ARN of an existing CloudWatch Log Group (must start with `aws-waf-logs-`), Kinesis Firehose, or S3 bucket to receive WAF logs. Null + create\_log\_group=true uses the auto-created log group. | `string` | `null` | no |
| <a name="input_log_kms_key_arn"></a> [log\_kms\_key\_arn](#input\_log\_kms\_key\_arn) | KMS key ARN to encrypt the auto-created log group. Null uses AWS-managed encryption. | `string` | `null` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Retention for the auto-created log group (only used when create\_log\_group = true). | `number` | `30` | no |
| <a name="input_logging_enabled"></a> [logging\_enabled](#input\_logging\_enabled) | Enable WAF logging via `aws_wafv2_web_acl_logging_configuration`. Requires either log\_destination\_arn OR create\_log\_group. | `bool` | `true` | no |
| <a name="input_managed_rule_groups"></a> [managed\_rule\_groups](#input\_managed\_rule\_groups) | AWS Managed Rule Groups to attach. Each entry: { name, priority, override (optional, `none` to enforce or `count` to monitor only) }. | <pre>list(object({<br/>    name     = string<br/>    priority = number<br/>    override = optional(string, "none")<br/>  }))</pre> | <pre>[<br/>  {<br/>    "name": "AWSManagedRulesCommonRuleSet",<br/>    "override": "none",<br/>    "priority": 10<br/>  },<br/>  {<br/>    "name": "AWSManagedRulesKnownBadInputsRuleSet",<br/>    "override": "none",<br/>    "priority": 20<br/>  },<br/>  {<br/>    "name": "AWSManagedRulesAmazonIpReputationList",<br/>    "override": "none",<br/>    "priority": 30<br/>  }<br/>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Web ACL. Used as the CloudWatch metric base name and as the prefix for derived rule names. | `string` | n/a | yes |
| <a name="input_rate_limit_per_header"></a> [rate\_limit\_per\_header](#input\_rate\_limit\_per\_header) | Per-header rate-based rule (custom aggregate key): `{ priority, limit, header_name }` (5-min sliding window, lowercased). Null disables this rule. | <pre>object({<br/>    priority    = number<br/>    limit       = number<br/>    header_name = string<br/>  })</pre> | `null` | no |
| <a name="input_rate_limit_per_ip"></a> [rate\_limit\_per\_ip](#input\_rate\_limit\_per\_ip) | Per-IP rate-based rule: `{ priority, limit }` (5-min sliding window). Null disables this rule. | <pre>object({<br/>    priority = number<br/>    limit    = number<br/>  })</pre> | `null` | no |
| <a name="input_sampled_requests_enabled"></a> [sampled\_requests\_enabled](#input\_sampled\_requests\_enabled) | Enable sampled-requests collection in the WAF console. | `bool` | `true` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | Scope of the Web ACL. REGIONAL (for ALB / API Gateway / AppSync / App Runner / Cognito user pool) or CLOUDFRONT (must be created in us-east-1). | `string` | `"REGIONAL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the Web ACL and (when created) the log group. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | ARN of the auto-created CloudWatch Log Group, or null when create\_log\_group = false. |
| <a name="output_logging_configuration_resource_arn"></a> [logging\_configuration\_resource\_arn](#output\_logging\_configuration\_resource\_arn) | Resource ARN of the WAF logging configuration, or null when logging\_enabled = false. |
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | ARN of the Web ACL. |
| <a name="output_web_acl_capacity"></a> [web\_acl\_capacity](#output\_web\_acl\_capacity) | Web ACL capacity units consumed by the configured rules. |
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | ID of the Web ACL. |
| <a name="output_web_acl_name"></a> [web\_acl\_name](#output\_web\_acl\_name) | Name of the Web ACL. |

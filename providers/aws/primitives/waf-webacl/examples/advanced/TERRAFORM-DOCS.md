<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_waf_webacl"></a> [waf\_webacl](#module\_waf\_webacl) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_metrics_enabled"></a> [cloudwatch\_metrics\_enabled](#input\_cloudwatch\_metrics\_enabled) | Whether to enable CloudWatch metrics for the WebACL | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Friendly description of the WebACL | `string` | `null` | no |
| <a name="input_enable_core_rule_set"></a> [enable\_core\_rule\_set](#input\_enable\_core\_rule\_set) | Whether to enable the AWSManagedRulesCommonRuleSet | `bool` | `true` | no |
| <a name="input_enable_ip_reputation_rule_set"></a> [enable\_ip\_reputation\_rule\_set](#input\_enable\_ip\_reputation\_rule\_set) | Whether to enable the AWSManagedRulesAmazonIpReputationList | `bool` | `true` | no |
| <a name="input_enable_ip_set_rule"></a> [enable\_ip\_set\_rule](#input\_enable\_ip\_set\_rule) | Whether to enable the IP set block rule | `bool` | `true` | no |
| <a name="input_enable_known_bad_inputs_rule_set"></a> [enable\_known\_bad\_inputs\_rule\_set](#input\_enable\_known\_bad\_inputs\_rule\_set) | Whether to enable the AWSManagedRulesKnownBadInputsRuleSet | `bool` | `true` | no |
| <a name="input_enable_rate_based_rule"></a> [enable\_rate\_based\_rule](#input\_enable\_rate\_based\_rule) | Whether to enable the per-IP rate-based rule | `bool` | `true` | no |
| <a name="input_enable_tool_header_rate_rule"></a> [enable\_tool\_header\_rate\_rule](#input\_enable\_tool\_header\_rate\_rule) | Whether to enable the X-Caylent-Tool header rate-based rule | `bool` | `true` | no |
| <a name="input_ip_set_addresses"></a> [ip\_set\_addresses](#input\_ip\_set\_addresses) | List of IPv4 CIDR ranges to block | `list(string)` | `[]` | no |
| <a name="input_ip_set_rule_name"></a> [ip\_set\_rule\_name](#input\_ip\_set\_rule\_name) | Name for the IP set block rule | `string` | `"block-ip-set"` | no |
| <a name="input_ip_set_rule_priority"></a> [ip\_set\_rule\_priority](#input\_ip\_set\_rule\_priority) | Priority of the IP set block rule | `number` | `30` | no |
| <a name="input_name"></a> [name](#input\_name) | Friendly name of the WebACL | `string` | n/a | yes |
| <a name="input_rate_based_rule_limit"></a> [rate\_based\_rule\_limit](#input\_rate\_based\_rule\_limit) | Per-IP request limit per 5-minute window | `number` | `2000` | no |
| <a name="input_rate_based_rule_priority"></a> [rate\_based\_rule\_priority](#input\_rate\_based\_rule\_priority) | Priority of the per-IP rate-based rule | `number` | `10` | no |
| <a name="input_sampled_requests_enabled"></a> [sampled\_requests\_enabled](#input\_sampled\_requests\_enabled) | Whether to enable sampled request storage | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_tool_header_name"></a> [tool\_header\_name](#input\_tool\_header\_name) | HTTP header name used as the custom aggregate key | `string` | `"x-caylent-tool"` | no |
| <a name="input_tool_header_rate_rule_limit"></a> [tool\_header\_rate\_rule\_limit](#input\_tool\_header\_rate\_rule\_limit) | Tool-header rate limit per 5-minute window | `number` | `1000` | no |
| <a name="input_tool_header_rate_rule_priority"></a> [tool\_header\_rate\_rule\_priority](#input\_tool\_header\_rate\_rule\_priority) | Priority of the X-Caylent-Tool header rate-based rule | `number` | `20` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_set_arn"></a> [ip\_set\_arn](#output\_ip\_set\_arn) | The ARN of the IP block set |
| <a name="output_ip_set_id"></a> [ip\_set\_id](#output\_ip\_set\_id) | The ID of the IP block set |
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | The ARN of the WAFv2 Web ACL |
| <a name="output_web_acl_capacity"></a> [web\_acl\_capacity](#output\_web\_acl\_capacity) | Web ACL capacity units (WCUs) consumed |
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | The ID of the WAFv2 Web ACL |
| <a name="output_web_acl_name"></a> [web\_acl\_name](#output\_web\_acl\_name) | The name of the WAFv2 Web ACL |
<!-- END_TF_DOCS -->
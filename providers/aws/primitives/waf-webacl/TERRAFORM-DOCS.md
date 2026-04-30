## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_ip_set.blocked](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_logging_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input__wafv2_core_rule_group_name"></a> [\_wafv2\_core\_rule\_group\_name](#input\_\_wafv2\_core\_rule\_group\_name) | AWS managed rule group name for core rules. Must be AWSManagedRulesCommonRuleSet. | `string` | `"AWSManagedRulesCommonRuleSet"` | no |
| <a name="input__wafv2_header_oversize_handling"></a> [\_wafv2\_header\_oversize\_handling](#input\_\_wafv2\_header\_oversize\_handling) | AWS WAFv2 oversize handling for custom header keys. Must be one of: CONTINUE, MATCH, NO_MATCH. | `string` | `"CONTINUE"` | no |
| <a name="input__wafv2_ip_reputation_rule_group_name"></a> [\_wafv2\_ip\_reputation\_rule\_group\_name](#input\_\_wafv2\_ip\_reputation\_rule\_group\_name) | AWS managed rule group name for IP reputation. Must be AWSManagedRulesAmazonIpReputationList. | `string` | `"AWSManagedRulesAmazonIpReputationList"` | no |
| <a name="input__wafv2_ip_version_ipv4"></a> [\_wafv2\_ip\_version\_ipv4](#input\_\_wafv2\_ip\_version\_ipv4) | AWS WAFv2 IP version for IPv4 sets. Must be IPV4. | `string` | `"IPV4"` | no |
| <a name="input__wafv2_known_bad_inputs_rule_group_name"></a> [\_wafv2\_known\_bad\_inputs\_rule\_group\_name](#input\_\_wafv2\_known\_bad\_inputs\_rule\_group\_name) | AWS managed rule group name for known bad inputs. Must be AWSManagedRulesKnownBadInputsRuleSet. | `string` | `"AWSManagedRulesKnownBadInputsRuleSet"` | no |
| <a name="input__wafv2_rate_limit_aggregation_key_type_custom"></a> [\_wafv2\_rate\_limit\_aggregation\_key\_type\_custom](#input\_\_wafv2\_rate\_limit\_aggregation\_key\_type\_custom) | AWS WAFv2 aggregate key type for custom header rate limiting. Must be CUSTOM\_KEYS. | `string` | `"CUSTOM_KEYS"` | no |
| <a name="input__wafv2_rate_limit_aggregation_key_type_ip"></a> [\_wafv2\_rate\_limit\_aggregation\_key\_type\_ip](#input\_\_wafv2\_rate\_limit\_aggregation\_key\_type\_ip) | AWS WAFv2 aggregate key type for IP-based rate limiting. Must be IP. | `string` | `"IP"` | no |
| <a name="input__wafv2_scope_regional"></a> [\_wafv2\_scope\_regional](#input\_\_wafv2\_scope\_regional) | AWS WAFv2 scope value for regional resources. Must be REGIONAL. | `string` | `"REGIONAL"` | no |
| <a name="input__wafv2_vendor_name"></a> [\_wafv2\_vendor\_name](#input\_\_wafv2\_vendor\_name) | AWS vendor name for managed rule groups. Must be AWS. | `string` | `"AWS"` | no |
| <a name="input_cloudwatch_metrics_enabled"></a> [cloudwatch\_metrics\_enabled](#input\_cloudwatch\_metrics\_enabled) | (Optional) Whether to enable CloudWatch metrics for the WebACL. | `bool` | `true` | no |
| <a name="input_core_rule_set_priority"></a> [core\_rule\_set\_priority](#input\_core\_rule\_set\_priority) | (Optional) Priority of the AWSManagedRulesCommonRuleSet rule group. | `number` | `40` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) Friendly description of the WebACL. | `string` | `null` | no |
| <a name="input_enable_core_rule_set"></a> [enable\_core\_rule\_set](#input\_enable\_core\_rule\_set) | (Optional) Whether to enable the AWSManagedRulesCommonRuleSet managed rule group. | `bool` | `true` | no |
| <a name="input_enable_ip_reputation_rule_set"></a> [enable\_ip\_reputation\_rule\_set](#input\_enable\_ip\_reputation\_rule\_set) | (Optional) Whether to enable the AWSManagedRulesAmazonIpReputationList managed rule group. | `bool` | `true` | no |
| <a name="input_enable_ip_set_rule"></a> [enable\_ip\_set\_rule](#input\_enable\_ip\_set\_rule) | (Optional) Whether to enable the IP set block rule. | `bool` | `false` | no |
| <a name="input_enable_known_bad_inputs_rule_set"></a> [enable\_known\_bad\_inputs\_rule\_set](#input\_enable\_known\_bad\_inputs\_rule\_set) | (Optional) Whether to enable the AWSManagedRulesKnownBadInputsRuleSet managed rule group. | `bool` | `true` | no |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | (Optional) Whether to enable WAF logging to a Kinesis Firehose or S3 destination. | `bool` | `false` | no |
| <a name="input_enable_rate_based_rule"></a> [enable\_rate\_based\_rule](#input\_enable\_rate\_based\_rule) | (Optional) Whether to enable the default per-IP rate-based rule. | `bool` | `true` | no |
| <a name="input_enable_tool_header_rate_rule"></a> [enable\_tool\_header\_rate\_rule](#input\_enable\_tool\_header\_rate\_rule) | (Optional) Whether to enable the rate-based rule that aggregates on the X-Caylent-Tool HTTP header. | `bool` | `true` | no |
| <a name="input_ip_reputation_rule_set_priority"></a> [ip\_reputation\_rule\_set\_priority](#input\_ip\_reputation\_rule\_set\_priority) | (Optional) Priority of the AWSManagedRulesAmazonIpReputationList rule group. | `number` | `60` | no |
| <a name="input_ip_set_addresses"></a> [ip\_set\_addresses](#input\_ip\_set\_addresses) | (Optional) List of CIDR ranges to block. IPv4 (e.g. 192.0.2.0/24) ranges are accepted. | `list(string)` | `[]` | no |
| <a name="input_ip_set_rule_name"></a> [ip\_set\_rule\_name](#input\_ip\_set\_rule\_name) | (Optional) Name for the IP set block rule. | `string` | `"block-ip-set"` | no |
| <a name="input_ip_set_rule_priority"></a> [ip\_set\_rule\_priority](#input\_ip\_set\_rule\_priority) | (Optional) Priority of the IP set block rule. | `number` | `30` | no |
| <a name="input_known_bad_inputs_rule_set_priority"></a> [known\_bad\_inputs\_rule\_set\_priority](#input\_known\_bad\_inputs\_rule\_set\_priority) | (Optional) Priority of the AWSManagedRulesKnownBadInputsRuleSet rule group. | `number` | `50` | no |
| <a name="input_logging_destination_arns"></a> [logging\_destination\_arns](#input\_logging\_destination\_arns) | (Optional) List of ARNs of the logging destinations (Kinesis Firehose or S3). Required when enable\_logging is true. | `list(string)` | `[]` | no |
| <a name="input_managed_by_tag"></a> [managed\_by\_tag](#input\_managed\_by\_tag) | (Optional) Value for the ManagedBy tag applied to all resources. | `string` | `"terraform"` | no |
| <a name="input_module_tag"></a> [module\_tag](#input\_module\_tag) | (Optional) Value for the Module tag applied to all resources. | `string` | `"waf-webacl"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Friendly name of the WebACL. | `string` | n/a | yes |
| <a name="input_rate_based_rule_limit"></a> [rate\_based\_rule\_limit](#input\_rate\_based\_rule\_limit) | (Optional) Aggregate request limit per 5-minute window for the per-IP rate-based rule. | `number` | `2000` | no |
| <a name="input_rate_based_rule_name"></a> [rate\_based\_rule\_name](#input\_rate\_based\_rule\_name) | (Optional) Name for the per-IP rate-based rule. | `string` | `"rate-limit-per-ip"` | no |
| <a name="input_rate_based_rule_priority"></a> [rate\_based\_rule\_priority](#input\_rate\_based\_rule\_priority) | (Optional) Priority of the per-IP rate-based rule. Lower numbers are evaluated first. | `number` | `10` | no |
| <a name="input_resource_arns"></a> [resource\_arns](#input\_resource\_arns) | (Optional) List of ARNs of resources to associate with the WebACL (ALB, API Gateway REST API, AppSync GraphQL API, Cognito User Pool, App Runner Service, Verified Access Instance). | `list(string)` | `[]` | no |
| <a name="input_sampled_requests_enabled"></a> [sampled\_requests\_enabled](#input\_sampled\_requests\_enabled) | (Optional) Whether AWS WAF should store a sampling of the web requests that match the rules. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the WebACL and associated resources. | `map(string)` | `{}` | no |
| <a name="input_tool_header_name"></a> [tool\_header\_name](#input\_tool\_header\_name) | (Optional) The HTTP header name used as the custom aggregate key for the tool-header rate rule. | `string` | `"x-caylent-tool"` | no |
| <a name="input_tool_header_rate_rule_limit"></a> [tool\_header\_rate\_rule\_limit](#input\_tool\_header\_rate\_rule\_limit) | (Optional) Aggregate request limit per 5-minute window for the X-Caylent-Tool header rate-based rule. | `number` | `1000` | no |
| <a name="input_tool_header_rate_rule_name"></a> [tool\_header\_rate\_rule\_name](#input\_tool\_header\_rate\_rule\_name) | (Optional) Name for the X-Caylent-Tool header rate-based rule. | `string` | `"rate-limit-per-tool-header"` | no |
| <a name="input_tool_header_rate_rule_priority"></a> [tool\_header\_rate\_rule\_priority](#input\_tool\_header\_rate\_rule\_priority) | (Optional) Priority of the X-Caylent-Tool header rate-based rule. | `number` | `20` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_set_arn"></a> [ip\_set\_arn](#output\_ip\_set\_arn) | The ARN of the IP set used for blocking, or null if the IP set rule is not enabled. |
| <a name="output_ip_set_id"></a> [ip\_set\_id](#output\_ip\_set\_id) | The ID of the IP set used for blocking, or null if the IP set rule is not enabled. |
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | The ARN of the WAFv2 Web ACL. |
| <a name="output_web_acl_capacity"></a> [web\_acl\_capacity](#output\_web\_acl\_capacity) | The web ACL capacity units (WCUs) currently used by the Web ACL. |
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | The ID of the WAFv2 Web ACL. |
| <a name="output_web_acl_name"></a> [web\_acl\_name](#output\_web\_acl\_name) | The name of the WAFv2 Web ACL. |
| <a name="output_web_acl_tags_all"></a> [web\_acl\_tags\_all](#output\_web\_acl\_tags\_all) | A map of tags assigned to the Web ACL, including those inherited from the provider default\_tags configuration block. |

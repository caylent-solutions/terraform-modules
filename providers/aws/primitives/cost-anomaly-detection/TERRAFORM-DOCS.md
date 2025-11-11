## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ce_anomaly_monitor.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_monitor) | resource |
| [aws_ce_anomaly_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ce_anomaly_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_subscription"></a> [create\_subscription](#input\_create\_subscription) | Whether to create a cost anomaly subscription | `bool` | `true` | no |
| <a name="input_monitor_dimension"></a> [monitor\_dimension](#input\_monitor\_dimension) | Dimension for DIMENSIONAL monitor type (SERVICE, LINKED\_ACCOUNT, etc.) | `string` | `"SERVICE"` | no |
| <a name="input_monitor_name"></a> [monitor\_name](#input\_monitor\_name) | Name of the cost anomaly monitor | `string` | `null` | no |
| <a name="input_monitor_specification"></a> [monitor\_specification](#input\_monitor\_specification) | JSON specification for CUSTOM monitor type | `string` | `null` | no |
| <a name="input_monitor_type"></a> [monitor\_type](#input\_monitor\_type) | Type of monitor (DIMENSIONAL or CUSTOM) | `string` | `"DIMENSIONAL"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the cost anomaly detector | `string` | n/a | yes |
| <a name="input_subscribers"></a> [subscribers](#input\_subscribers) | List of subscribers for anomaly notifications | <pre>list(object({<br/>    type    = string<br/>    address = string<br/>  }))</pre> | `[]` | no |
| <a name="input_subscription_frequency"></a> [subscription\_frequency](#input\_subscription\_frequency) | Frequency of subscription notifications | `string` | `"DAILY"` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | Name of the cost anomaly subscription | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_threshold_amount"></a> [threshold\_amount](#input\_threshold\_amount) | Threshold amount for anomaly alerts (in USD) | `number` | `100` | no |
| <a name="input_threshold_key"></a> [threshold\_key](#input\_threshold\_key) | Threshold key for anomaly detection | `string` | `"ANOMALY_TOTAL_IMPACT_ABSOLUTE"` | no |
| <a name="input_threshold_match_options"></a> [threshold\_match\_options](#input\_threshold\_match\_options) | Match options for threshold | `list(string)` | <pre>[<br/>  "GREATER_THAN_OR_EQUAL"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_anomaly_monitor_arn"></a> [anomaly\_monitor\_arn](#output\_anomaly\_monitor\_arn) | ARN of the cost anomaly monitor |
| <a name="output_anomaly_monitor_name"></a> [anomaly\_monitor\_name](#output\_anomaly\_monitor\_name) | Name of the cost anomaly monitor |
| <a name="output_anomaly_subscription_arn"></a> [anomaly\_subscription\_arn](#output\_anomaly\_subscription\_arn) | ARN of the cost anomaly subscription |
| <a name="output_anomaly_subscription_name"></a> [anomaly\_subscription\_name](#output\_anomaly\_subscription\_name) | Name of the cost anomaly subscription |

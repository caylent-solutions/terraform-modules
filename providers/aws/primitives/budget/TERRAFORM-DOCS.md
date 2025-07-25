## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.34.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.34.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | (Optional) The ID of the account associated with this budget. | `string` | `null` | no |
| <a name="input_auto_adjust_data"></a> [auto\_adjust\_data](#input\_auto\_adjust\_data) | (Optional) Configuration for auto-adjusting the budget based on forecast or historical data. | <pre>object({<br/>    auto_adjust_type = string<br/>    historical_options = optional(object({<br/>      budget_adjustment_period = number<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_budget_type"></a> [budget\_type](#input\_budget\_type) | (Required) Type of budget. Valid values: USAGE, COST, RI\_UTILIZATION, RI\_COVERAGE, SAVINGS\_PLANS\_UTILIZATION, SAVINGS\_PLANS\_COVERAGE. | `string` | n/a | yes |
| <a name="input_cost_filter"></a> [cost\_filter](#input\_cost\_filter) | (Optional) Filters for refining budget scope. Each key is a dimension and the value is a list of values to filter on. | `map(list(string))` | `{}` | no |
| <a name="input_cost_types"></a> [cost\_types](#input\_cost\_types) | (Optional) Configuration for types of costs to include in the budget. | <pre>object({<br/>    include_credit             = optional(bool)<br/>    include_discount           = optional(bool)<br/>    include_other_subscription = optional(bool)<br/>    include_recurring          = optional(bool)<br/>    include_refund             = optional(bool)<br/>    include_subscription       = optional(bool)<br/>    include_support            = optional(bool)<br/>    include_tax                = optional(bool)<br/>    include_upfront            = optional(bool)<br/>    use_blended                = optional(bool)<br/>  })</pre> | `null` | no |
| <a name="input_limit_amount"></a> [limit\_amount](#input\_limit\_amount) | (Optional) The amount of cost or usage being measured for a budget. Required unless auto\_adjust\_data is set. | `number` | `null` | no |
| <a name="input_limit_unit"></a> [limit\_unit](#input\_limit\_unit) | (Optional) The unit of measurement used for the budget forecast, actual spend, or budget threshold, e.g., USD. | `string` | `"USD"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the budget. | `string` | n/a | yes |
| <a name="input_notification"></a> [notification](#input\_notification) | (Optional) Budget notifications with associated subscribers. | <pre>list(object({<br/>    comparison_operator        = string<br/>    threshold                  = number<br/>    threshold_type             = string<br/>    notification_type          = string<br/>    subscriber_sns_topic_arns  = optional(list(string))<br/>    subscriber_email_addresses = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags assigned to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |
| <a name="input_time_period_end"></a> [time\_period\_end](#input\_time\_period\_end) | (Optional) The end of the time period covered by the budget, in RFC3339 format. | `string` | `null` | no |
| <a name="input_time_period_start"></a> [time\_period\_start](#input\_time\_period\_start) | (Optional) The start of the time period covered by the budget, in RFC3339 format. | `string` | `null` | no |
| <a name="input_time_unit"></a> [time\_unit](#input\_time\_unit) | (Optional) The length of time until a budget resets the actual and forecasted spend. Valid values: DAILY, MONTHLY, QUARTERLY, ANNUALLY. | `string` | `"MONTHLY"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | The AWS Account ID the budget is associated with. |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the AWS Budget. |
| <a name="output_cost_filter"></a> [cost\_filter](#output\_cost\_filter) | Cost filter map applied to the budget. |
| <a name="output_limit_amount"></a> [limit\_amount](#output\_limit\_amount) | The limit amount set for the budget. |
| <a name="output_limit_unit"></a> [limit\_unit](#output\_limit\_unit) | The unit of the limit amount (e.g., USD). |
| <a name="output_name"></a> [name](#output\_name) | The name of the AWS Budget. |
| <a name="output_notifications"></a> [notifications](#output\_notifications) | Notification settings for the budget. |
| <a name="output_time_unit"></a> [time\_unit](#output\_time\_unit) | The time unit for the budget (e.g., MONTHLY, QUARTERLY). |
| <a name="output_type"></a> [type](#output\_type) | The budget type (e.g., COST, USAGE). |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.99.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.99.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_budget"></a> [budget](#module\_budget) | ../../ | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | ~> 1.0 |
| <a name="module_sns_budget"></a> [sns\_budget](#module\_sns\_budget) | terraform-aws-modules/sns/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.99.0/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subscriber_email_addresses"></a> [subscriber\_email\_addresses](#input\_subscriber\_email\_addresses) | Email addresses used for budget alert sns notifications | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the Budgets | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_budget_account_id"></a> [budget\_account\_id](#output\_budget\_account\_id) | The AWS Account ID the budget is associated with. |
| <a name="output_budget_arn"></a> [budget\_arn](#output\_budget\_arn) | The ARN of the AWS Budget. |
| <a name="output_budget_cost_filter"></a> [budget\_cost\_filter](#output\_budget\_cost\_filter) | Cost filter map applied to the budget. |
| <a name="output_budget_limit_amount"></a> [budget\_limit\_amount](#output\_budget\_limit\_amount) | The limit amount set for the budget. |
| <a name="output_budget_limit_unit"></a> [budget\_limit\_unit](#output\_budget\_limit\_unit) | The unit of the limit amount (e.g., USD). |
| <a name="output_budget_name"></a> [budget\_name](#output\_budget\_name) | The name of the AWS Budget. |
| <a name="output_budget_notifications"></a> [budget\_notifications](#output\_budget\_notifications) | Notification settings for the budget. |
| <a name="output_budget_time_unit"></a> [budget\_time\_unit](#output\_budget\_time\_unit) | The time unit for the budget (e.g., MONTHLY, QUARTERLY). |
| <a name="output_budget_type"></a> [budget\_type](#output\_budget\_type) | The budget type (e.g., COST, USAGE). |

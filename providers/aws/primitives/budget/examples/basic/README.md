# Basic Example

This directory contains a basic example of how to use the Budget module with minimal configuration.

## Usage

```hcl
module "budget" {
  source = "../../"

  name         = "monthly-cost-budget"
  budget_type  = "COST"
  limit_amount = 1000
  time_unit    = "MONTHLY"
  tags = {
    ManagedBy = "terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.99.0 |

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
```
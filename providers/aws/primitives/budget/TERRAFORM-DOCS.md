## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.34.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_budgets"></a> [budgets](#input\_budgets) | List of budget definitions | <pre>map(object({<br/>    # Required<br/>    name         = string<br/>    budget_type  = string # USAGE, COST, RI_UTILIZATION, RI_COVERAGE, SAVINGS_PLANS_UTILIZATION, SAVINGS_PLANS_COVERAGE<br/>    limit_amount = number<br/>    time_unit    = optional(string, "MONTHLY") # MONTHLY, QUARTERLY, ANNUALLY, and DAILY<br/><br/>    # Optional<br/>    account_id        = optional(string)<br/>    limit_unit        = optional(string, "USD")<br/>    time_period_start = optional(string)<br/>    time_period_end   = optional(string)<br/><br/>    auto_adjust_data = optional(object({<br/>      auto_adjust_type = string # FORECAST, HISTORICAL<br/>      historical_options = optional(object({<br/>        budget_adjustment_period = number<br/>      }))<br/>    }))<br/><br/>    cost_types = optional(object({<br/>      include_credit             = optional(bool)<br/>      include_discount           = optional(bool)<br/>      include_other_subscription = optional(bool)<br/>      include_recurring          = optional(bool)<br/>      include_refund             = optional(bool)<br/>      include_subscription       = optional(bool)<br/>      include_support            = optional(bool)<br/>      include_tax                = optional(bool)<br/>      include_upfront            = optional(bool)<br/>      use_blended                = optional(bool) # Defaults to false<br/>    }))<br/><br/>    cost_filter = optional(map(list(string))) # https://registry.terraform.io/providers/-/aws/latest/docs/resources/budgets_budget#cost-filter<br/><br/>    notification = optional(list(object({<br/>      comparison_operator        = string # LESS_THAN, EQUAL_TO or GREATER_THAN<br/>      threshold                  = number<br/>      threshold_type             = string # PERCENTAGE, ABSOLUTE_VALUE<br/>      notification_type          = string # ACTUAL, FORECASTED<br/>      subscriber_sns_topic_arns  = optional(list(string))<br/>      subscriber_email_addresses = optional(list(string))<br/>    })))<br/><br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags assigned to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_budgets"></a> [budgets](#output\_budgets) | List of Budgets that are being managed by this module |

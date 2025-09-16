# Basic Example

This directory contains a basic example of how to use the Chatbot module with minimal configuration.

## Usage

```hcl
module "chatbot_test_sns" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 5.0"

  name = "chatbot-test-sns-topic"

  tags = {
    Name = "chatbot-test-sns-topic"
  }
}

module "chatbot" {
  source = "../../"

  chatbot_name            = "aws-chatbot"
  create_default_iam_role = true
  slack_channel_configurations = {
    "terraform-aws-chatbot" = {
      configuration_name = "terraform-aws-chatbot-slack"
      slack_channel_id   = "C07VDLX6KAR"
      slack_team_id      = "T0C0RPJGN"
      sns_topic_arns     = [module.chatbot_test_sns.topic_arn]
    }
  }

  teams_channel_configurations = {
    "terraform-aws-chatbot" = {
      configuration_name = "terraform-aws-chatbot-teams"
      channel_id         = "19%3AmClUolIkLiqQtIBNQCh3J4aQqEJ9jOHTU93AYfHDA5c1%40thread.tacv2"
      team_id            = "680e968a-3e01-4119-abbf-1a4458f9ea22"
      tenant_id          = "7346df00-af54-41f4-b792-a4f465b5b568"
      sns_topic_arns     = [module.chatbot_test_sns.topic_arn]
    }
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
| <a name="input_budgets"></a> [budgets](#input\_budgets) | List of budget definitions | <pre>map(object({<br>    # Required<br>    name         = string<br>    budget_type  = string # USAGE, COST, RI_UTILIZATION, RI_COVERAGE, SAVINGS_PLANS_UTILIZATION, SAVINGS_PLANS_COVERAGE<br>    limit_amount = number<br>    time_unit    = optional(string, "MONTHLY") # MONTHLY, QUARTERLY, ANNUALLY, and DAILY<br><br>    # Optional<br>    account_id        = optional(string)<br>    limit_unit        = optional(string, "USD")<br>    time_period_start = optional(string)<br>    time_period_end   = optional(string)<br><br>    auto_adjust_data = optional(object({<br>      auto_adjust_type = string # FORECAST, HISTORICAL<br>      historical_options = optional(object({<br>        budget_adjustment_period = number<br>      }))<br>    }))<br><br>    cost_types = optional(object({<br>      include_credit             = optional(bool)<br>      include_discount           = optional(bool)<br>      include_other_subscription = optional(bool)<br>      include_recurring          = optional(bool)<br>      include_refund             = optional(bool)<br>      include_subscription       = optional(bool)<br>      include_support            = optional(bool)<br>      include_tax                = optional(bool)<br>      include_upfront            = optional(bool)<br>      use_blended                = optional(bool) # Defaults to false<br>    }))<br><br>    cost_filter = optional(map(list(string))) # https://registry.terraform.io/providers/-/aws/latest/docs/resources/budgets_budget#cost-filter<br><br>    notification = optional(list(object({<br>      comparison_operator        = string # LESS_THAN, EQUAL_TO or GREATER_THAN<br>      threshold                  = number<br>      threshold_type             = string # PERCENTAGE, ABSOLUTE_VALUE<br>      notification_type          = string # ACTUAL, FORECASTED<br>      subscriber_sns_topic_arns  = optional(list(string))<br>      subscriber_email_addresses = optional(list(string))<br>    })))<br><br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the Budgets | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_budgets"></a> [budgets](#output\_budgets) | List of Budgets that are being managed by this module |

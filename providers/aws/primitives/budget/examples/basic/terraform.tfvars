tags = {
  Environment = "test"
  Purpose     = "budget-module-testing"
  Owner       = "terraform"
  Source      = "caylent-solutions/terraform-modules/providers/aws/primitives/budget"
}

budgets = {
  monthly-cost-budget = {
    name         = "tf-modules-monthly-cost-budget"
    budget_type  = "COST"
    limit_amount = 1000
    time_unit    = "MONTHLY"

    notification = [
      {
        comparison_operator        = "GREATER_THAN"
        threshold                  = 80
        threshold_type             = "PERCENTAGE"
        notification_type          = "ACTUAL"
        subscriber_email_addresses = ["your@email.com"]
        subscriber_sns_topic_arns  = ["arn:aws:sns:us-east-1:131578276461:budget-alerts"]
      }
    ]
  },
  all-options-budget = {
    name         = "tf-modules-all-options-budget"
    budget_type  = "COST"
    limit_amount = 2000
    time_unit    = "MONTHLY"
    #   account_id   = "111111111111"
    limit_unit        = "USD"
    time_period_start = "2025-01-01_00:00"
    time_period_end   = "2025-12-31_23:59"

    # auto_adjust_data = {
    #   auto_adjust_type = "HISTORICAL"
    #   historical_options = {
    #     budget_adjustment_period = 3
    #   }
    # }

    cost_types = {
      include_credit             = true
      include_discount           = true
      include_other_subscription = true
      include_recurring          = true
      include_refund             = false
      include_subscription       = true
      include_support            = true
      include_tax                = true
      include_upfront            = true
      use_blended                = false
    }

    cost_filter = {
      # TagKeyValue = ["Environment$Production"]
      Region = ["us-east-1"]
    }

    notification = [
      {
        comparison_operator        = "GREATER_THAN"
        threshold                  = 80
        threshold_type             = "PERCENTAGE"
        notification_type          = "ACTUAL"
        subscriber_email_addresses = ["your@email.com"]
        subscriber_sns_topic_arns  = ["arn:aws:sns:us-east-1:131578276461:budget-alerts"]
      },
      {
        comparison_operator        = "GREATER_THAN"
        threshold                  = 95
        threshold_type             = "PERCENTAGE"
        notification_type          = "FORECASTED"
        subscriber_email_addresses = ["your@email.com"]
        subscriber_sns_topic_arns  = ["arn:aws:sns:us-east-1:131578276461:budget-alerts"]
      }
    ]
  }
}

data "aws_caller_identity" "current" {}

module "sns_budget" {
  source = "terraform-aws-modules/sns/aws"

  name = "budget-alerts"

  kms_master_key_id = module.kms.key_arn

  create_topic_policy         = true
  enable_default_topic_policy = true
  topic_policy_statements = {
    budgets = {
      actions = ["sns:Publish"]
      principals = [{
        type = "Service"
        identifiers = [
          "budgets.amazonaws.com",
          "cloudwatch.amazonaws.com",
          "events.amazonaws.com",
          "costalerts.amazonaws.com"
        ]
      }]
      condition = {
        test     = "StringEquals"
        variable = "aws:SourceAccount"
        values   = [data.aws_caller_identity.current.account_id]
      }
    }
  }
}

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.0"

  aliases     = ["aws-budgets"]
  description = "KMS key for AWS Budgets"
  key_usage   = "ENCRYPT_DECRYPT"

  # Key policy
  key_statements = [
    {
      sid = "AllowServicePrincipals"
      actions = [
        "kms:GenerateDataKey*",
        "kms:Decrypt"
      ]
      principals = [{
        type = "Service"
        identifiers = [
          "budgets.amazonaws.com",
          "sns.amazonaws.com",
          "cloudwatch.amazonaws.com",
          "events.amazonaws.com",
          "costalerts.amazonaws.com"
        ]
      }]
      resources = ["*"]
    }
  ]
}


module "budgets" {
  source = "../../"

  enabled = true

  budgets = [

    {
      name         = "monthly-cost-budget-basic"
      budget_type  = "COST"
      limit_amount = 1000
      time_unit    = "MONTHLY"

      notification = [
        {
          comparison_operator        = "GREATER_THAN"
          threshold                  = 80
          threshold_type             = "PERCENTAGE"
          notification_type          = "ACTUAL"
          subscriber_email_addresses = var.subscriber_email_addresses
          subscriber_sns_topic_arns  = [module.sns_budget.topic_arn]
        }
      ]
    },
    {
      name         = "linked-account-budget-basic"
      budget_type  = "COST"
      limit_amount = 500
      time_unit    = "MONTHLY"

      cost_filter = {
        # Only works in management account
        # LinkedAccount = ["999999999999", "888888888888"]
      }

      notification = [
        {
          comparison_operator        = "GREATER_THAN"
          threshold                  = 90
          threshold_type             = "PERCENTAGE"
          notification_type          = "FORECASTED"
          subscriber_email_addresses = var.subscriber_email_addresses
          subscriber_sns_topic_arns  = [module.sns_budget.topic_arn]
        }
      ]
    },
    {
      name        = "all-options-budget-basic"
      budget_type = "COST"
      time_unit   = "MONTHLY"
      #   account_id   = "111111111111"
      limit_unit        = "USD"
      time_period_start = "2025-01-01_00:00"
      time_period_end   = "2025-12-31_23:59"

      auto_adjust_data = {
        auto_adjust_type = "HISTORICAL"
        historical_options = {
          budget_adjustment_period = 3
        }
      }

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
          subscriber_email_addresses = var.subscriber_email_addresses
          subscriber_sns_topic_arns  = [module.sns_budget.topic_arn]
        },
        {
          comparison_operator        = "GREATER_THAN"
          threshold                  = 95
          threshold_type             = "PERCENTAGE"
          notification_type          = "FORECASTED"
          subscriber_email_addresses = var.subscriber_email_addresses
          subscriber_sns_topic_arns  = [module.sns_budget.topic_arn]
        }
      ]
    }
  ]
  
  tags = var.tags
}

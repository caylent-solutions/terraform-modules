# AWS Budget Terraform Module

This module is a simple abstraction on top of the aws_budgets_budget resource. It allows you to create multiple budgets in a single module call. Take a look at the example for a handy reference and variables.tf for the full list of configurable options as well as some of the available values.

## Key Features
- Configure Cost or Usage-based budgets.
- Establish which [cost types](https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_budgets_CostTypes.html) the budget track.
- Create [cost filters](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-create-filters.html) for the budget.
- Set notification alerts when thresholds are met.

## Quick Start

### Basic Budget
```hcl
module "budget" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/budget?ref=providers/aws/primitives/vpc/v1.0.0"
  budgets = {
    monthly-cost-budget = {
      name         = "monthly-cost-budget"
      budget_type  = "COST"
      limit_amount = 1000
      time_unit    = "MONTHLY"
    }
  }
  tags = {
    ManagedBy = "terraform"
  }
}
```


### Budget with notification
```hcl
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

module "budget" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/budget?ref=providers/aws/primitives/vpc/v1.0.0"

  budgets = {
     monthly-cost-budget = {
      name         = "monthly-cost-budget"
      budget_type  = "COST"
      limit_amount = 1000
      time_unit    = "MONTHLY"

      notification = [
        {
          comparison_operator        = "GREATER_THAN"
          threshold                  = 80
          threshold_type             = "PERCENTAGE"
          notification_type          = "ACTUAL"
          subscriber_email_addresses = local.subscriber_email_addresses
          subscriber_sns_topic_arns  = [module.sns_budget.topic_arn]
        }
      ]

    }
  }
  tags = {
    ManagedBy = "terraform"
  }
}
```

## Examples

See the [examples](examples/) directory for complete working examples:

- [Basic Budget](examples/basic/) - A budget implementation with all features.

## Technical Documentation

For detailed technical specifications including all inputs, outputs, and resources, see [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).
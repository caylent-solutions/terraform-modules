data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Local values to construct dynamic SNS topic ARN
locals {
  sns_topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:budget-alerts"

  # Transform budgets to replace placeholder SNS ARN with actual ARN
  budgets_with_dynamic_sns = {
    for k, v in var.budgets : k => merge(v, {
      notification = v.notification != null ? [
        for notification in v.notification : merge(notification, {
          subscriber_sns_topic_arns = notification.subscriber_sns_topic_arns != null ? [
            for arn in notification.subscriber_sns_topic_arns :
            arn == "PLACEHOLDER_SNS_TOPIC_ARN" ? local.sns_topic_arn : arn
          ] : null
        })
      ] : null
    })
  }
}

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
  tags = var.tags
}

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.0"

  aliases                 = ["aws-budgets"]
  description             = "KMS key for AWS Budgets"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7

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
  tags = var.tags
}


module "budget" {
  source  = "../../"
  budgets = local.budgets_with_dynamic_sns

  tags = var.tags

  depends_on = [module.sns_budget]
}

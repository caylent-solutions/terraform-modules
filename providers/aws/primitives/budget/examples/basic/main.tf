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
  budgets = var.budgets

  tags = var.tags

  depends_on = [module.sns_budget]
}

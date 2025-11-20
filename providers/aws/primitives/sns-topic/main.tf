locals {
  default_kms_key = "alias/aws/sns"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "default" {
  count = var.create_default_policy && var.policy == null ? 1 : 0

  statement {
    sid    = "AllowAccountOwner"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission"
    ]
    resources = [aws_sns_topic.this.arn]
  }

  dynamic "statement" {
    for_each = length(var.allowed_aws_principals) > 0 ? [1] : []
    content {
      sid    = "AllowAWSPrincipals"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = var.allowed_aws_principals
      }
      actions   = ["SNS:Publish"]
      resources = [aws_sns_topic.this.arn]
    }
  }

  dynamic "statement" {
    for_each = length(var.allowed_service_principals) > 0 ? [1] : []
    content {
      sid    = "AllowServicePrincipals"
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = var.allowed_service_principals
      }
      actions   = ["SNS:Publish"]
      resources = [aws_sns_topic.this.arn]
    }
  }
}

resource "aws_sns_topic" "this" {
  name              = var.name
  kms_master_key_id = var.kms_master_key_id != null ? var.kms_master_key_id : (var.enable_default_encryption ? local.default_kms_key : null)
  delivery_policy   = var.delivery_policy

  http_success_feedback_role_arn           = var.enable_delivery_status_logging ? var.http_success_feedback_role_arn : null
  http_failure_feedback_role_arn           = var.enable_delivery_status_logging ? var.http_failure_feedback_role_arn : null
  http_success_feedback_sample_rate        = var.enable_delivery_status_logging ? var.http_success_feedback_sample_rate : null
  lambda_success_feedback_role_arn         = var.enable_delivery_status_logging ? var.lambda_success_feedback_role_arn : null
  lambda_failure_feedback_role_arn         = var.enable_delivery_status_logging ? var.lambda_failure_feedback_role_arn : null
  lambda_success_feedback_sample_rate      = var.enable_delivery_status_logging ? var.lambda_success_feedback_sample_rate : null
  sqs_success_feedback_role_arn            = var.enable_delivery_status_logging ? var.sqs_success_feedback_role_arn : null
  sqs_failure_feedback_role_arn            = var.enable_delivery_status_logging ? var.sqs_failure_feedback_role_arn : null
  sqs_success_feedback_sample_rate         = var.enable_delivery_status_logging ? var.sqs_success_feedback_sample_rate : null
  application_success_feedback_role_arn    = var.enable_delivery_status_logging ? var.application_success_feedback_role_arn : null
  application_failure_feedback_role_arn    = var.enable_delivery_status_logging ? var.application_failure_feedback_role_arn : null
  application_success_feedback_sample_rate = var.enable_delivery_status_logging ? var.application_success_feedback_sample_rate : null

  tags = var.tags
}

resource "aws_sns_topic_policy" "this" {
  count  = var.policy != null || var.create_default_policy ? 1 : 0
  arn    = aws_sns_topic.this.arn
  policy = var.policy != null ? var.policy : data.aws_iam_policy_document.default[0].json
}


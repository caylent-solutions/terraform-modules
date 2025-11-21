data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  
  # Cross-account policy allowing specific accounts and service principals
  topic_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCurrentAccount"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        }
        Action = [
          "SNS:GetTopicAttributes",
          "SNS:SetTopicAttributes",
          "SNS:AddPermission",
          "SNS:RemovePermission",
          "SNS:DeleteTopic",
          "SNS:Subscribe",
          "SNS:ListSubscriptionsByTopic",
          "SNS:Publish"
        ]
        Resource = "arn:aws:sns:*:${local.account_id}:${var.name}"
      },
      {
        Sid    = "AllowExternalAccountPublish"
        Effect = "Allow"
        Principal = {
          AWS = var.allowed_aws_accounts
        }
        Action   = "SNS:Publish"
        Resource = "arn:aws:sns:*:${local.account_id}:${var.name}"
      },
      {
        Sid    = "AllowS3ServicePublish"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = "arn:aws:sns:*:${local.account_id}:${var.name}"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
        }
      }
    ]
  })
}

module "sns_topic" {
  source = "../../"

  name              = var.name
  policy            = local.topic_policy
  kms_master_key_id = var.kms_master_key_id
  tags              = var.tags
}

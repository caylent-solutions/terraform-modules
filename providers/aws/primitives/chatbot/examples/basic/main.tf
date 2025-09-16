# The Local values below are only required if using tfvars to pass values to the chatbot module resource,
# given that the SNS topic `chatbot_test_sns` is created after terraform performs the static checks on it's variables. 
# If your deployment of the module doesn't require de use of tfvars, you can go and replace the `local.slack_channel_configurations_with_dynamic_sns`
# and `local.teams_channel_configurations_with_dynamic_sns` with `var.slack_channel_configurations` and `var.teams_channel_configurations`.

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  sns_topic_arn = "arn:aws:sns:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:${var.sns_chatbot_name}"
  # Transform budgets to replace placeholder SNS ARN with actual ARN
  slack_channel_configurations_with_dynamic_sns = {
    for k, v in var.slack_channel_configurations : k => merge(v, {
      sns_topic_arns = v.sns_topic_arns != null ? [
        for arn in v.sns_topic_arns : arn == "PLACEHOLDER_SNS_TOPIC_ARN" ? local.sns_topic_arn : arn
      ] : null
    })
  }

  teams_channel_configurations_with_dynamic_sns = {
    for k, v in var.teams_channel_configurations : k => merge(v, {
      sns_topic_arns = v.sns_topic_arns != null ? [
        for arn in v.sns_topic_arns : arn == "PLACEHOLDER_SNS_TOPIC_ARN" ? local.sns_topic_arn : arn
      ] : null
    })
  }

}

module "chatbot_test_sns" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 5.0"

  name = var.sns_chatbot_name

  tags = {
    Name = var.sns_chatbot_name
  }
}

module "chatbot" {
  source = "../../"

  iam_chatbot_name             = var.iam_chatbot_name
  create_default_iam_role      = var.create_default_iam_role
  slack_channel_configurations = local.slack_channel_configurations_with_dynamic_sns
  teams_channel_configurations = local.teams_channel_configurations_with_dynamic_sns
}
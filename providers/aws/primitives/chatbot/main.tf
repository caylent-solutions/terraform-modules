resource "aws_chatbot_slack_channel_configuration" "slack_channels" {
  for_each = var.slack_channel_configurations

  configuration_name    = each.value.configuration_name
  iam_role_arn          = each.value.iam_role_arn != null ? each.value.iam_role_arn : aws_iam_role.chatbot_role[0].arn
  slack_channel_id      = each.value.slack_channel_id
  slack_team_id         = each.value.slack_team_id
  guardrail_policy_arns = each.value.guardrail_policy_arns
  logging_level         = each.value.logging_level
  sns_topic_arns        = each.value.sns_topic_arns

  tags = {
    Name = each.value.configuration_name
  }
}

resource "aws_chatbot_teams_channel_configuration" "teams_channels" {
  for_each = var.teams_channel_configurations

  configuration_name    = each.value.configuration_name
  iam_role_arn          = each.value.iam_role_arn != null ? each.value.iam_role_arn : aws_iam_role.chatbot_role[0].arn
  channel_id            = each.value.channel_id
  team_id               = each.value.team_id
  tenant_id             = each.value.tenant_id
  guardrail_policy_arns = each.value.guardrail_policy_arns
  logging_level         = each.value.logging_level
  sns_topic_arns        = each.value.sns_topic_arns

  tags = {
    Name = each.value.configuration_name
  }
}

resource "aws_iam_role" "chatbot_role" {
  count              = var.create_default_iam_role ? 1 : 0
  name               = var.iam_chatbot_name
  assume_role_policy = data.aws_iam_policy_document.chatbot_assume_role.json
}

resource "aws_iam_policy" "chatbot_policy" {
  count       = var.create_default_iam_role ? 1 : 0
  name        = var.iam_chatbot_name
  description = "Policy for AWS Chatbot"
  policy      = data.aws_iam_policy_document.chatbot_policy.json
}

resource "aws_iam_role_policy_attachment" "chatbot_policy_attachment" {
  count      = var.create_default_iam_role ? 1 : 0
  role       = aws_iam_role.chatbot_role[0].name
  policy_arn = aws_iam_policy.chatbot_policy[0].arn
}

data "aws_iam_policy_document" "chatbot_policy" {
  # Monitoring permissions
  statement {
    actions = [
      "autoscaling:Describe*",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "logs:Get*",
      "logs:List*",
      "logs:Describe*",
      "logs:TestMetricFilter",
      "logs:FilterLogEvents",
      "sns:Get*",
      "sns:List*"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "cloudwatch:PutMetricData",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "sns:Publish"
    ]
    resources = ["*"]
  }
}


data "aws_iam_policy_document" "chatbot_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["chatbot.amazonaws.com"]
    }
  }
}

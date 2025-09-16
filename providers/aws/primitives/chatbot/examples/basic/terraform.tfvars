sns_chatbot_name        = "chatbot-test-sns-topic"
iam_chatbot_name        = "aws-chatbot"
create_default_iam_role = true
slack_channel_configurations = {
  "terraform-aws-chatbot" = {
    configuration_name = "terraform-aws-chatbot-slack"
    slack_channel_id   = "C07VDLX6KAR"
    slack_team_id      = "T0C0RPJGN"
    sns_topic_arns     = ["PLACEHOLDER_SNS_TOPIC_ARN"]
  }
}

teams_channel_configurations = {
  "terraform-aws-chatbot" = {
    configuration_name = "terraform-aws-chatbot-teams"
    channel_id         = "19%3AmClUolIkLiqQtIBNQCh3J4aQqEJ9jOHTU93AYfHDA5c1%40thread.tacv2"
    team_id            = "680e968a-3e01-4119-abbf-1a4458f9ea22"
    tenant_id          = "7346df00-af54-41f4-b792-a4f465b5b568"
    sns_topic_arns     = ["PLACEHOLDER_SNS_TOPIC_ARN"]
  }
}
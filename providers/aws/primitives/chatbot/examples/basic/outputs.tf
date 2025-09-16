output "aws_chatbot_slack_channel" {
  description = "aws chatbot slack channel configuration"
  value       = module.chatbot.aws_chatbot_slack_channel
}

output "aws_chatbot_teams_channel" {
  description = "aws chatbot teams channel configuration"
  value       = module.chatbot.aws_chatbot_teams_channel
}

output "aws_chatbot_slack_channel" {
  description = "aws chatbot slack channel configuration"
  value       = aws_chatbot_slack_channel_configuration.slack_channels
}

output "aws_chatbot_teams_channel" {
  description = "aws chatbot teams channel configuration"
  value       = aws_chatbot_teams_channel_configuration.teams_channels
}

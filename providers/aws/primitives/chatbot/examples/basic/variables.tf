variable "sns_chatbot_name" {
  description = "Name of the SNS topic used by AWS Chatbot"
  type        = string
}

variable "iam_chatbot_name" {
  description = "Used to uniquely identify IAM resources."
  type        = string
}

variable "create_default_iam_role" {
  description = <<EOF
If true, a default IAM role and policy will be created.
If false, the user must provide an existing IAM role
with the necessary permissions for every channel configuration.
If defined, "iam_role_arn" is used instead of the default role.
EOF
  type        = bool
  default     = true
}

variable "slack_channel_configurations" {
  type = map(object({
    configuration_name = string
    iam_role_arn       = optional(string) # User-defined role that AWS Chatbot assumes. This is not the service-linked role
    slack_channel_id   = string           # For example, C07EZ1ABC23
    slack_team_id      = string           # This is the ID you get when you authorize the Slack workspace with AWS Chatbot in UI. See README.md for more details.

    # Optionals
    guardrail_policy_arns       = optional(list(string)) # The AWS managed AdministratorAccess policy is applied by default if this is not set
    logging_level               = optional(string)       # ERROR, INFO, or NONE
    sns_topic_arns              = optional(list(string))
    user_authorization_required = optional(bool)
  }))
  description = "Map of Slack channel configurations"
}

variable "teams_channel_configurations" {
  type = map(object({
    configuration_name = string
    iam_role_arn       = optional(string) # User-defined role that AWS Chatbot assumes. This is not the service-linked role
    channel_id         = string           # For example, "19%3AmClUolIkLiqQtIBNQCh3J4aQqEJ9jOHTU93AYfHDA5c1%40thread.tacv2"
    team_id            = string           # For example, "680e968a-3e01-4119-abbf-1a4458f9ea22"
    tenant_id          = string           # For example, "7346df00-af54-41f4-b792-a4f465b5b568."

    # Optionals
    guardrail_policy_arns       = optional(list(string)) # The AWS managed AdministratorAccess policy is applied by default if this is not set
    logging_level               = optional(string)       # ERROR, INFO, or NONE
    sns_topic_arns              = optional(list(string))
    user_authorization_required = optional(bool)
  }))
  description = "Map of Teams channel configurations"
}

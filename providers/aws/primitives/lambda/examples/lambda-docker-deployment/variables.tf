variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "ssm_config_value" {
  description = "Value to store in the SSM parameter for extension config"
  type        = string
  sensitive   = false
  default     = "placeholder-config"
}

variable "api_token_secret_string" {
  description = "Secret string to store as the API token secret"
  type        = string
  sensitive   = true
}

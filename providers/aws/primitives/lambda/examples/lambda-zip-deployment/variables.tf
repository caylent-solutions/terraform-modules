variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "ssm_api_key_value" {
  description = "Value to store in the SSM SecureString parameter for API key"
  type        = string
  sensitive   = true
}

variable "db_secret_string" {
  description = "JSON string to store as the database credentials secret"
  type        = string
  sensitive   = true
}

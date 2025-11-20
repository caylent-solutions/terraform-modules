variable "name" {
  description = "The name of the SNS topic."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the topic."
  type        = map(string)
  default     = {}
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK. Set to empty string to disable encryption."
  type        = string
  default     = "alias/aws/sns"
}

variable "policy" {
  description = "The fully-formed AWS policy as JSON for the SNS topic"
  type        = string
  default     = null
}

variable "delivery_policy" {
  description = "The SNS delivery policy as JSON"
  type        = string
  default     = null
}

variable "enable_delivery_status_logging" {
  description = "Enable delivery status logging for all subscription types"
  type        = bool
  default     = false
}

variable "http_success_feedback_role_arn" {
  description = "IAM role ARN for successful HTTP deliveries"
  type        = string
  default     = null
}

variable "http_failure_feedback_role_arn" {
  description = "IAM role ARN for failed HTTP deliveries"
  type        = string
  default     = null
}

variable "lambda_success_feedback_role_arn" {
  description = "IAM role ARN for successful Lambda deliveries"
  type        = string
  default     = null
}

variable "lambda_failure_feedback_role_arn" {
  description = "IAM role ARN for failed Lambda deliveries"
  type        = string
  default     = null
}

variable "sqs_success_feedback_role_arn" {
  description = "IAM role ARN for successful SQS deliveries"
  type        = string
  default     = null
}

variable "sqs_failure_feedback_role_arn" {
  description = "IAM role ARN for failed SQS deliveries"
  type        = string
  default     = null
}

variable "application_success_feedback_role_arn" {
  description = "IAM role ARN for successful application deliveries"
  type        = string
  default     = null
}

variable "application_failure_feedback_role_arn" {
  description = "IAM role ARN for failed application deliveries"
  type        = string
  default     = null
}

variable "http_success_feedback_sample_rate" {
  description = "Percentage of successful HTTP deliveries to log (0-100)"
  type        = number
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  description = "Percentage of successful Lambda deliveries to log (0-100)"
  type        = number
  default     = null
}

variable "sqs_success_feedback_sample_rate" {
  description = "Percentage of successful SQS deliveries to log (0-100)"
  type        = number
  default     = null
}

variable "application_success_feedback_sample_rate" {
  description = "Percentage of successful application deliveries to log (0-100)"
  type        = number
  default     = null
}

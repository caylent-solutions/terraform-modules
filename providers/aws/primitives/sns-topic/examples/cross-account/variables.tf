variable "name" {
  description = "The name of the SNS topic."
  type        = string
}

variable "kms_master_key_id" {
  description = "The ID or ARN of a customer-managed KMS key for SNS encryption."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the topic."
  type        = map(string)
  default     = {}
}

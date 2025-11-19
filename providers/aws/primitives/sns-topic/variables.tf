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
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK"
  type        = string
  default     = null
}

variable "enable_default_encryption" {
  description = "Enable default encryption using AWS managed keys"
  type        = bool
  default     = true
}

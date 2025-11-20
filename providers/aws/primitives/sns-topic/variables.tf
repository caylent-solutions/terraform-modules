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

variable "policy" {
  description = "The fully-formed AWS policy as JSON. If not set, allows all AWS accounts to publish"
  type        = string
  default     = null
}

variable "create_default_policy" {
  description = "Create a default policy that allows only the account owner to publish/subscribe"
  type        = bool
  default     = true
}

variable "allowed_aws_principals" {
  description = "List of AWS principal ARNs allowed to publish to this topic"
  type        = list(string)
  default     = []
}

variable "allowed_service_principals" {
  description = "List of AWS service principals allowed to publish (e.g., 's3.amazonaws.com')"
  type        = list(string)
  default     = []
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "image_command" {
  description = "Command override for the container image"
  type        = list(string)
  default     = null
}

variable "architectures" {
  description = "Instruction set architecture"
  type        = list(string)
  default     = ["x86_64"]
}

variable "timeout" {
  description = "Function timeout in seconds"
  type        = number
  default     = 60
}

variable "memory_size" {
  description = "Function memory in MB"
  type        = number
  default     = 512
}

variable "environment_variables" {
  description = "Environment variables for the function"
  type        = map(string)
  default     = null
}

variable "enable_vpc" {
  description = "Whether to enable VPC configuration"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "VPC subnet IDs"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "VPC security group IDs"
  type        = list(string)
  default     = []
}

variable "enable_event_source" {
  description = "Whether to create SQS event source"
  type        = bool
  default     = true
}

variable "batch_size" {
  description = "Event source batch size"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

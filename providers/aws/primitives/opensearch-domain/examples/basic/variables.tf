variable "domain_name_prefix" {
  description = "Base domain name (a random suffix is appended)."
  type        = string
}

variable "engine_version" {
  description = "OpenSearch engine version."
  type        = string
  default     = "OpenSearch_2.13"
}

variable "instance_type" {
  description = "Data node instance type."
  type        = string
  default     = "t3.small.search"
}

variable "instance_count" {
  description = "Number of data nodes."
  type        = number
  default     = 1
}

variable "log_retention_in_days" {
  description = "Application log retention."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

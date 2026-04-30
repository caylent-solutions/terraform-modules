variable "secret_name" {
  description = "Base secret name (a random suffix is appended)."
  type        = string
}

variable "rotation_automatically_after_days" {
  description = "Rotation cadence in days."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

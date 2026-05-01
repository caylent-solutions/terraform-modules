variable "bus_name" {
  description = "Base bus name (a random suffix is appended)."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

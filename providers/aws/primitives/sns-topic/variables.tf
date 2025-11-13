variable "name" {
  description = "The name of the SNS topic."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the topic."
  type        = map(string)
  default     = {}
}

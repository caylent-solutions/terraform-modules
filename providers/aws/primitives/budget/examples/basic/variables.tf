variable "subscriber_email_addresses" {
  description = "Email addresses used for budget alert sns notifications"
  type        = list(string)
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Budgets"
  default     = {}
}
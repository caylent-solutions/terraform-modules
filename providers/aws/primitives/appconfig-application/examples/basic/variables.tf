variable "application_name" {
  description = "Base AppConfig application name (a random suffix is appended)."
  type        = string
}

variable "deployment_duration_in_minutes" {
  description = "Total deployment duration in minutes."
  type        = number
  default     = 5
}

variable "deployment_final_bake_time_in_minutes" {
  description = "Bake time after rollout completes."
  type        = number
  default     = 5
}

variable "deployment_growth_factor" {
  description = "Percentage of targets advanced per step."
  type        = number
  default     = 20
}

variable "deployment_growth_type" {
  description = "LINEAR or EXPONENTIAL growth function."
  type        = string
  default     = "LINEAR"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

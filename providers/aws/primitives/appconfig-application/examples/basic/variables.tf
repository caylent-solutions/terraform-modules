variable "name" {
  type        = string
  description = "Name for the AppConfig application."
}

variable "description" {
  type        = string
  description = "Description for the AppConfig application."
  default     = ""
}

variable "environment_name" {
  type        = string
  description = "Name for the AppConfig environment."
}

variable "environment_description" {
  type        = string
  description = "Description for the AppConfig environment."
  default     = ""
}

variable "configuration_profile_name" {
  type        = string
  description = "Name for the AppConfig configuration profile."
}

variable "configuration_profile_description" {
  type        = string
  description = "Description for the AppConfig configuration profile."
  default     = ""
}

variable "deployment_strategy_name" {
  type        = string
  description = "Name for the AppConfig deployment strategy."
}

variable "deployment_strategy_description" {
  type        = string
  description = "Description for the AppConfig deployment strategy."
  default     = ""
}

variable "deployment_duration_in_minutes" {
  type        = number
  description = "Total amount of time in minutes for a deployment to last."
  default     = 5
}

variable "growth_factor" {
  type        = number
  description = "The percentage of targets to receive a deployed configuration during each interval."
  default     = 20
}

variable "growth_type" {
  type        = string
  description = "The algorithm used to define how percentage grows over time."
  default     = "LINEAR"
}

variable "replicate_to" {
  type        = string
  description = "Where to save the deployment strategy."
  default     = "NONE"
}

variable "final_bake_time_in_minutes" {
  type        = number
  description = "The amount of time AppConfig monitors for alarms after the configuration has been deployed to 100% of its targets."
  default     = 0
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  default     = {}
}

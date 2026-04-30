variable "name" {
  type        = string
  description = "(Required) Name for the AppConfig application and associated resources."

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "name must be between 1 and 64 characters."
  }
}

variable "description" {
  type        = string
  description = "(Optional) Description for the AppConfig application."
  default     = ""
}

variable "environment_name" {
  type        = string
  description = "(Required) Name for the AppConfig environment."

  validation {
    condition     = length(var.environment_name) >= 1 && length(var.environment_name) <= 64
    error_message = "environment_name must be between 1 and 64 characters."
  }
}

variable "environment_description" {
  type        = string
  description = "(Optional) Description for the AppConfig environment."
  default     = ""
}

variable "configuration_profile_name" {
  type        = string
  description = "(Required) Name for the AppConfig configuration profile."

  validation {
    condition     = length(var.configuration_profile_name) >= 1 && length(var.configuration_profile_name) <= 64
    error_message = "configuration_profile_name must be between 1 and 64 characters."
  }
}

variable "configuration_profile_description" {
  type        = string
  description = "(Optional) Description for the AppConfig configuration profile."
  default     = ""
}

variable "deployment_strategy_name" {
  type        = string
  description = "(Required) Name for the AppConfig deployment strategy."

  validation {
    condition     = length(var.deployment_strategy_name) >= 1 && length(var.deployment_strategy_name) <= 64
    error_message = "deployment_strategy_name must be between 1 and 64 characters."
  }
}

variable "deployment_strategy_description" {
  type        = string
  description = "(Optional) Description for the AppConfig deployment strategy."
  default     = ""
}

variable "deployment_duration_in_minutes" {
  type        = number
  description = "(Optional) Total amount of time in minutes for a deployment to last. Defaults to 5 minutes (linear 5-step over 5 minutes)."
  default     = 5

  validation {
    condition     = var.deployment_duration_in_minutes >= 0 && var.deployment_duration_in_minutes <= 1440
    error_message = "deployment_duration_in_minutes must be between 0 and 1440."
  }
}

variable "growth_factor" {
  type        = number
  description = "(Optional) The percentage of targets to receive a deployed configuration during each interval. Defaults to 20 (linear 5-step: 5 steps x 20% = 100%)."
  default     = 20

  validation {
    condition     = var.growth_factor >= 1 && var.growth_factor <= 100
    error_message = "growth_factor must be between 1 and 100."
  }
}

variable "growth_type" {
  type        = string
  description = "(Optional) The algorithm used to define how percentage grows over time. Valid values: LINEAR, EXPONENTIAL."
  default     = "LINEAR"

  validation {
    condition     = contains(["LINEAR", "EXPONENTIAL"], var.growth_type)
    error_message = "growth_type must be one of: LINEAR, EXPONENTIAL."
  }
}

variable "replicate_to" {
  type        = string
  description = "(Optional) Where to save the deployment strategy. Valid values: NONE, SSM_DOCUMENT."
  default     = "NONE"

  validation {
    condition     = contains(["NONE", "SSM_DOCUMENT"], var.replicate_to)
    error_message = "replicate_to must be one of: NONE, SSM_DOCUMENT."
  }
}

variable "final_bake_time_in_minutes" {
  type        = number
  description = "(Optional) The amount of time AppConfig monitors for Amazon CloudWatch alarms after the configuration has been deployed to 100% of its targets, before considering the deployment to be complete."
  default     = 0

  validation {
    condition     = var.final_bake_time_in_minutes >= 0 && var.final_bake_time_in_minutes <= 1440
    error_message = "final_bake_time_in_minutes must be between 0 and 1440."
  }
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A map of tags to assign to the resources."
  default     = {}
}

variable "_configuration_profile_location_uri" {
  type        = string
  description = "AWS API constant: location URI for hosted configuration profiles."
  default     = "hosted"
}

variable "_configuration_profile_type" {
  type        = string
  description = "AWS API constant: configuration profile type for feature flags."
  default     = "AWS.AppConfig.FeatureFlags"
}

variable "managed_by_tag" {
  type        = string
  description = "(Optional) Value for the ManagedBy tag."
  default     = "terraform"
}

variable "module_tag" {
  type        = string
  description = "(Optional) Value for the Module tag."
  default     = "appconfig-application"
}

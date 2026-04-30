variable "name" {
  description = "Name of the AppConfig application."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{1,64}$", var.name))
    error_message = "Application name must be 1-64 characters and contain only alphanumerics, dots, hyphens, and underscores."
  }
}

variable "description" {
  description = "Description of the AppConfig application."
  type        = string
  default     = null
}

variable "environments" {
  description = "Map of environments to create. Key is the logical id; value is `{ name, description (optional), monitors (optional list of { alarm_arn, alarm_role_arn (optional) }) }`."
  type = map(object({
    name        = string
    description = optional(string)
    monitors = optional(list(object({
      alarm_arn      = string
      alarm_role_arn = optional(string)
    })), [])
  }))
  default = {}
}

variable "configuration_profiles" {
  description = "Map of configuration profiles to create. Key is the logical id; value is `{ name, description (optional), type (e.g. AWS.AppConfig.FeatureFlags or AWS.Freeform), location_uri (optional, defaults to `hosted`) }`."
  type = map(object({
    name         = string
    description  = optional(string)
    type         = string
    location_uri = optional(string)
  }))
  default = {}
}

variable "create_deployment_strategy" {
  description = "Whether to create a per-application deployment strategy. AWS provides a built-in `AppConfig.AllAtOnce` strategy; create one here for finer-grained linear/exponential rollouts."
  type        = bool
  default     = true
}

variable "deployment_strategy_description" {
  description = "Description for the deployment strategy."
  type        = string
  default     = null
}

variable "deployment_duration_in_minutes" {
  description = "Total deployment duration in minutes (0-1440). Default 5 minutes for a 5-step LINEAR rollout (per Q6 spec)."
  type        = number
  default     = 5

  validation {
    condition     = var.deployment_duration_in_minutes >= 0 && var.deployment_duration_in_minutes <= 1440
    error_message = "deployment_duration_in_minutes must be 0-1440."
  }
}

variable "deployment_final_bake_time_in_minutes" {
  description = "Bake time after rollout completes (0-1440)."
  type        = number
  default     = 5

  validation {
    condition     = var.deployment_final_bake_time_in_minutes >= 0 && var.deployment_final_bake_time_in_minutes <= 1440
    error_message = "deployment_final_bake_time_in_minutes must be 0-1440."
  }
}

variable "deployment_growth_factor" {
  description = "Percentage of targets advanced per step (1-100). Default 20 produces 5 steps when growth_type = LINEAR."
  type        = number
  default     = 20

  validation {
    condition     = var.deployment_growth_factor >= 1 && var.deployment_growth_factor <= 100
    error_message = "deployment_growth_factor must be 1-100."
  }
}

variable "deployment_growth_type" {
  description = "Growth function type. LINEAR (uniform per-step) or EXPONENTIAL (compounding)."
  type        = string
  default     = "LINEAR"

  validation {
    condition     = contains(["LINEAR", "EXPONENTIAL"], var.deployment_growth_type)
    error_message = "deployment_growth_type must be LINEAR or EXPONENTIAL."
  }
}

variable "deployment_replicate_to" {
  description = "Replication target. NONE (default) or SSM_DOCUMENT."
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["NONE", "SSM_DOCUMENT"], var.deployment_replicate_to)
    error_message = "deployment_replicate_to must be NONE or SSM_DOCUMENT."
  }
}

variable "tags" {
  description = "Tags applied to the application, environments, configuration profiles, and deployment strategy."
  type        = map(string)
  default     = {}
}

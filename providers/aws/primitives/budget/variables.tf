variable "name" {
  type        = string
  description = "(Required) Name of the budget."
}

variable "budget_type" {
  type        = string
  description = "(Required) Type of budget. Valid values: USAGE, COST, RI_UTILIZATION, RI_COVERAGE, SAVINGS_PLANS_UTILIZATION, SAVINGS_PLANS_COVERAGE."
}

variable "limit_amount" {
  type        = number
  description = "(Optional) The amount of cost or usage being measured for a budget. Required unless auto_adjust_data is set."
  default     = null
}

variable "time_unit" {
  type        = string
  description = "(Optional) The length of time until a budget resets the actual and forecasted spend. Valid values: DAILY, MONTHLY, QUARTERLY, ANNUALLY."
  default     = "MONTHLY"
}

variable "account_id" {
  type        = string
  description = "(Optional) The ID of the account associated with this budget."
  default     = null
}

variable "limit_unit" {
  type        = string
  description = "(Optional) The unit of measurement used for the budget forecast, actual spend, or budget threshold, e.g., USD."
  default     = "USD"
}

variable "time_period_start" {
  type        = string
  description = "(Optional) The start of the time period covered by the budget, in RFC3339 format."
  default     = null
}

variable "time_period_end" {
  type        = string
  description = "(Optional) The end of the time period covered by the budget, in RFC3339 format."
  default     = null
}

variable "auto_adjust_data" {
  type = object({
    auto_adjust_type = string
    historical_options = optional(object({
      budget_adjustment_period = number
    }))
  })
  description = "(Optional) Configuration for auto-adjusting the budget based on forecast or historical data."
  default     = null
}

variable "cost_types" {
  type = object({
    include_credit             = optional(bool)
    include_discount           = optional(bool)
    include_other_subscription = optional(bool)
    include_recurring          = optional(bool)
    include_refund             = optional(bool)
    include_subscription       = optional(bool)
    include_support            = optional(bool)
    include_tax                = optional(bool)
    include_upfront            = optional(bool)
    use_blended                = optional(bool)
  })
  description = "(Optional) Configuration for types of costs to include in the budget."
  default     = null
}

variable "cost_filter" {
  type        = map(list(string))
  description = "(Optional) Filters for refining budget scope. Each key is a dimension and the value is a list of values to filter on."
  default     = {}
}

variable "notification" {
  type = list(object({
    comparison_operator        = string
    threshold                  = number
    threshold_type             = string
    notification_type          = string
    subscriber_sns_topic_arns  = optional(list(string))
    subscriber_email_addresses = optional(list(string))
  }))
  description = "(Optional) Budget notifications with associated subscribers."
  default     = []
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Map of tags assigned to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
}
variable "budgets" {
  type = list(object({
    # Required
    name         = string
    budget_type  = string # USAGE, COST, RI_UTILIZATION, RI_COVERAGE, SAVINGS_PLANS_UTILIZATION, SAVINGS_PLANS_COVERAGE
    limit_amount = optional(number, null)
    time_unit    = optional(string, "MONTHLY") # MONTHLY, QUARTERLY, ANNUALLY, and DAILY

    # Optional
    account_id        = optional(string)
    limit_unit        = optional(string, "USD")
    time_period_start = optional(string)
    time_period_end   = optional(string)

    auto_adjust_data = optional(object({
      auto_adjust_type = string # FORECAST, HISTORICAL
      historical_options = optional(object({
        budget_adjustment_period = number
      }))
    }))

    cost_types = optional(object({
      include_credit             = optional(bool)
      include_discount           = optional(bool)
      include_other_subscription = optional(bool)
      include_recurring          = optional(bool)
      include_refund             = optional(bool)
      include_subscription       = optional(bool)
      include_support            = optional(bool)
      include_tax                = optional(bool)
      include_upfront            = optional(bool)
      use_blended                = optional(bool) # Defaults to false
    }))

    cost_filter = optional(map(list(string))) # https://registry.terraform.io/providers/-/aws/latest/docs/resources/budgets_budget#cost-filter

    notification = optional(list(object({
      comparison_operator        = string # LESS_THAN, EQUAL_TO or GREATER_THAN
      threshold                  = number
      threshold_type             = string # PERCENTAGE, ABSOLUTE_VALUE
      notification_type          = string # ACTUAL, FORECASTED
      subscriber_sns_topic_arns  = optional(list(string))
      subscriber_email_addresses = optional(list(string))
    })))

    tags = optional(map(string), {})

  }))
  description = "List of budget definitions"
}

variable "enabled" {
  type        = bool
  description = "Whether to create the resources."
  default     = true
}

variable "tags" {
  type = map(string)
  default = {}
  description = "(Optional) Map of tags assigned to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
}
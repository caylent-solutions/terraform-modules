output "budget_name" {
  description = "The name of the AWS Budget."
  value       = module.budget.name
}

output "budget_arn" {
  description = "The ARN of the AWS Budget."
  value       = module.budget.arn
}

output "budget_limit_amount" {
  description = "The limit amount set for the budget."
  value       = module.budget.limit_amount
}

output "budget_limit_unit" {
  description = "The unit of the limit amount (e.g., USD)."
  value       = module.budget.limit_unit
}

output "budget_time_unit" {
  description = "The time unit for the budget (e.g., MONTHLY, QUARTERLY)."
  value       = module.budget.time_unit
}

output "budget_type" {
  description = "The budget type (e.g., COST, USAGE)."
  value       = module.budget.type
}

output "budget_account_id" {
  description = "The AWS Account ID the budget is associated with."
  value       = module.budget.account_id
}

output "budget_notifications" {
  description = "Notification settings for the budget."
  value       = module.budget.notifications
}

output "budget_cost_filter" {
  description = "Cost filter map applied to the budget."
  value       = module.budget.cost_filter
}

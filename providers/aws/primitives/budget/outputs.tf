output "name" {
  description = "The name of the AWS Budget."
  value       = aws_budgets_budget.this.name
}

output "arn" {
  description = "The ARN of the AWS Budget."
  value       = aws_budgets_budget.this.arn
}

output "limit_amount" {
  description = "The limit amount set for the budget."
  value       = aws_budgets_budget.this.limit_amount
}

output "limit_unit" {
  description = "The unit of the limit amount (e.g., USD)."
  value       = aws_budgets_budget.this.limit_unit
}

output "time_unit" {
  description = "The time unit for the budget (e.g., MONTHLY, QUARTERLY)."
  value       = aws_budgets_budget.this.time_unit
}

output "type" {
  description = "The budget type (e.g., COST, USAGE)."
  value       = aws_budgets_budget.this.budget_type
}

output "account_id" {
  description = "The AWS Account ID the budget is associated with."
  value       = aws_budgets_budget.this.account_id
}

output "notifications" {
  description = "Notification settings for the budget."
  value       = aws_budgets_budget.this.notification
}

output "cost_filter" {
  description = "Cost filter map applied to the budget."
  value       = aws_budgets_budget.this.cost_filter
}

output "budgets" {
  description = "List of Budgets that are being managed by this module"
  value       = var.enabled ? aws_budgets_budget.this : null
}

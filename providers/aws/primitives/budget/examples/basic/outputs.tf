output "budgets" {
  description = "List of Budgets that are being managed by this module"
  value       = module.budget.budgets
}
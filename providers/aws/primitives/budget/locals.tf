locals {
  budgets = { for i, budget in var.budgets : budget.name => budget if var.enabled }
}
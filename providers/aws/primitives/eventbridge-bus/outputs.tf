output "bus_arn" {
  description = "ARN of the custom event bus."
  value       = aws_cloudwatch_event_bus.this.arn
}

output "bus_name" {
  description = "Name of the custom event bus."
  value       = aws_cloudwatch_event_bus.this.name
}

output "rule_arns" {
  description = "Map of rule logical ids to rule ARNs."
  value       = { for k, r in aws_cloudwatch_event_rule.this : k => r.arn }
}

output "rule_names" {
  description = "Map of rule logical ids to rule names."
  value       = { for k, r in aws_cloudwatch_event_rule.this : k => r.name }
}

output "target_ids" {
  description = "Map of target logical ids to target ids."
  value       = { for k, t in aws_cloudwatch_event_target.this : k => t.target_id }
}

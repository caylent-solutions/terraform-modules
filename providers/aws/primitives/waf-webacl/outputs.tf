output "web_acl_arn" {
  description = "ARN of the Web ACL."
  value       = aws_wafv2_web_acl.this.arn
}

output "web_acl_id" {
  description = "ID of the Web ACL."
  value       = aws_wafv2_web_acl.this.id
}

output "web_acl_name" {
  description = "Name of the Web ACL."
  value       = aws_wafv2_web_acl.this.name
}

output "web_acl_capacity" {
  description = "Web ACL capacity units consumed by the configured rules."
  value       = aws_wafv2_web_acl.this.capacity
}

output "log_group_arn" {
  description = "ARN of the auto-created CloudWatch Log Group, or null when create_log_group = false."
  value       = var.create_log_group ? aws_cloudwatch_log_group.waf[0].arn : null
}

output "logging_configuration_resource_arn" {
  description = "Resource ARN of the WAF logging configuration, or null when logging_enabled = false."
  value       = var.logging_enabled ? aws_wafv2_web_acl_logging_configuration.this[0].resource_arn : null
}

output "web_acl_id" {
  description = "The ID of the WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.this.id
}

output "web_acl_arn" {
  description = "The ARN of the WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.this.arn
}

output "web_acl_name" {
  description = "The name of the WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.this.name
}

output "web_acl_capacity" {
  description = "The web ACL capacity units (WCUs) currently used by the Web ACL."
  value       = aws_wafv2_web_acl.this.capacity
}

output "web_acl_tags_all" {
  description = "A map of tags assigned to the Web ACL, including those inherited from the provider default_tags configuration block."
  value       = aws_wafv2_web_acl.this.tags_all
}

output "ip_set_id" {
  description = "The ID of the IP set used for blocking, or null if the IP set rule is not enabled."
  value       = var.enable_ip_set_rule ? aws_wafv2_ip_set.blocked[0].id : null
}

output "ip_set_arn" {
  description = "The ARN of the IP set used for blocking, or null if the IP set rule is not enabled."
  value       = var.enable_ip_set_rule ? aws_wafv2_ip_set.blocked[0].arn : null
}

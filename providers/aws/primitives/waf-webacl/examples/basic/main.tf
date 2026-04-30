module "waf_webacl" {
  source = "../../"

  name        = var.name
  description = var.description
  tags        = var.tags

  enable_rate_based_rule   = var.enable_rate_based_rule
  rate_based_rule_limit    = var.rate_based_rule_limit
  rate_based_rule_priority = var.rate_based_rule_priority

  enable_tool_header_rate_rule   = var.enable_tool_header_rate_rule
  tool_header_rate_rule_limit    = var.tool_header_rate_rule_limit
  tool_header_rate_rule_priority = var.tool_header_rate_rule_priority
  tool_header_name               = var.tool_header_name

  enable_core_rule_set             = var.enable_core_rule_set
  enable_known_bad_inputs_rule_set = var.enable_known_bad_inputs_rule_set
  enable_ip_reputation_rule_set    = var.enable_ip_reputation_rule_set

  cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
  sampled_requests_enabled   = var.sampled_requests_enabled
}

output "web_acl_id" {
  description = "The ID of the WAFv2 Web ACL"
  value       = module.waf_webacl.web_acl_id
}

output "web_acl_arn" {
  description = "The ARN of the WAFv2 Web ACL"
  value       = module.waf_webacl.web_acl_arn
}

output "web_acl_name" {
  description = "The name of the WAFv2 Web ACL"
  value       = module.waf_webacl.web_acl_name
}

output "web_acl_capacity" {
  description = "Web ACL capacity units (WCUs) consumed"
  value       = module.waf_webacl.web_acl_capacity
}

output "web_acl_tags_all" {
  description = "All tags assigned to the Web ACL"
  value       = module.waf_webacl.web_acl_tags_all
}

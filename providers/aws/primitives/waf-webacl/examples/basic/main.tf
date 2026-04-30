resource "random_id" "suffix" {
  byte_length = 4
}

module "webacl" {
  source = "../../"

  name        = "${var.webacl_name}-${random_id.suffix.hex}"
  description = "Basic example for waf-webacl primitive"
  scope       = var.scope

  default_action = var.default_action

  cloudwatch_metrics_enabled = true
  sampled_requests_enabled   = true

  rate_limit_per_ip = {
    priority = 100
    limit    = var.rate_limit_per_ip
  }

  rate_limit_per_header = {
    priority    = 110
    limit       = var.rate_limit_per_header
    header_name = var.rate_limit_header_name
  }

  logging_enabled       = true
  create_log_group      = true
  log_retention_in_days = var.log_retention_in_days

  tags = var.tags
}

output "web_acl_arn" {
  description = "ARN of the Web ACL."
  value       = module.webacl.web_acl_arn
}

output "web_acl_name" {
  description = "Name of the Web ACL."
  value       = module.webacl.web_acl_name
}

output "web_acl_capacity" {
  description = "Web ACL capacity units consumed."
  value       = module.webacl.web_acl_capacity
}

output "log_group_arn" {
  description = "WAF log group ARN."
  value       = module.webacl.log_group_arn
}

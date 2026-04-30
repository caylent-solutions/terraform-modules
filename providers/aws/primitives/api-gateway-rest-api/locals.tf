locals {
  common_tags = merge(
    var.tags,
    {
      ManagedBy = var.managed_by_tag
      Module    = var.module_tag
    }
  )

  create_domain     = var.domain_name != null
  create_usage_plan = var.usage_plan_name != null
  create_waf        = var.web_acl_arn != null
}

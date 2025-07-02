# Local variables for the VPC module
locals {
  # Common tags to be applied to all resources
  common_tags = merge(
    var.tags,
    {
      ManagedBy = var.managed_by_tag
      Module    = var.module_tag
    }
  )

  # DNS configuration
  dns_support_enabled   = var.enable_dns_support
  dns_hostnames_enabled = var.enable_dns_hostnames && var.enable_dns_support
}
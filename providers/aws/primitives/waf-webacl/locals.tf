locals {
  common_tags = merge(
    var.tags,
    {
      ManagedBy = var.managed_by_tag
      Module    = var.module_tag
    }
  )
}

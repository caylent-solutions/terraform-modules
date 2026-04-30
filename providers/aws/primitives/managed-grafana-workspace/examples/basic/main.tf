module "grafana_workspace" {
  source = "../../"

  workspace_name      = var.workspace_name
  account_access_type = var.account_access_type
  auth_providers      = var.auth_providers
  permission_type     = var.permission_type
  data_sources        = var.data_sources

  notification_destinations = var.notification_destinations

  admin_sso_group_ids  = var.admin_sso_group_ids
  viewer_sso_group_ids = var.viewer_sso_group_ids

  tags = var.tags
}

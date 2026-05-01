resource "random_id" "suffix" {
  byte_length = 4
}

module "workspace" {
  source = "../../"

  workspace_name = "${var.workspace_name}-${random_id.suffix.hex}"
  description    = "Basic example for managed-grafana-workspace primitive"

  authentication_providers  = var.authentication_providers
  account_access_type       = var.account_access_type
  permission_type           = var.permission_type
  data_sources              = var.data_sources
  notification_destinations = var.notification_destinations

  tags = var.tags
}

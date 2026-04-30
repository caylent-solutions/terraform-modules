resource "aws_grafana_workspace" "this" {
  name                      = var.workspace_name
  account_access_type       = var.account_access_type
  authentication_providers  = var.auth_providers
  permission_type           = var.permission_type
  data_sources              = var.data_sources
  notification_destinations = var.notification_destinations

  dynamic "vpc_configuration" {
    for_each = var.vpc_configuration != null ? [var.vpc_configuration] : []
    content {
      security_group_ids = vpc_configuration.value.security_group_ids
      subnet_ids         = vpc_configuration.value.subnet_ids
    }
  }

  tags = var.tags
}

resource "aws_grafana_workspace_saml_configuration" "this" {
  count              = contains(var.auth_providers, var.saml_auth_provider_name) ? 1 : 0
  workspace_id       = aws_grafana_workspace.this.id
  editor_role_values = var.saml_editor_role_values
}

resource "aws_grafana_role_association" "admin" {
  count        = length(var.admin_sso_group_ids) > 0 ? 1 : 0
  role         = var.admin_role_name
  workspace_id = aws_grafana_workspace.this.id

  group_ids = var.admin_sso_group_ids
}

resource "aws_grafana_role_association" "viewer" {
  count        = length(var.viewer_sso_group_ids) > 0 ? 1 : 0
  role         = var.viewer_role_name
  workspace_id = aws_grafana_workspace.this.id

  group_ids = var.viewer_sso_group_ids
}

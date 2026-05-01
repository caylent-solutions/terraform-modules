resource "aws_iam_role" "workspace" {
  count = var.create_workspace_role ? 1 : 0

  name_prefix = substr("${var.workspace_name}${local.role_name_suffix}", 0, 38)

  assume_role_policy = data.aws_iam_policy_document.assume[0].json

  tags = var.tags
}

data "aws_iam_policy_document" "assume" {
  count = var.create_workspace_role ? 1 : 0

  statement {
    effect = local.effect_allow

    principals {
      type        = local.principal_type_service
      identifiers = [local.principal_grafana]
    }

    actions = [local.action_assume_role]
  }
}

resource "aws_grafana_workspace" "this" {
  name                      = var.workspace_name
  description               = var.description
  account_access_type       = var.account_access_type
  authentication_providers  = var.authentication_providers
  permission_type           = var.permission_type
  data_sources              = var.data_sources
  notification_destinations = var.notification_destinations

  role_arn = var.create_workspace_role ? aws_iam_role.workspace[0].arn : var.workspace_role_arn

  dynamic "vpc_configuration" {
    for_each = var.vpc_configuration == null ? [] : [var.vpc_configuration]
    content {
      subnet_ids         = vpc_configuration.value.subnet_ids
      security_group_ids = vpc_configuration.value.security_group_ids
    }
  }

  tags = var.tags
}

resource "aws_grafana_role_association" "admin" {
  count = length(var.admin_sso_group_ids) == 0 ? 0 : 1

  role         = local.role_admin
  workspace_id = aws_grafana_workspace.this.id

  group_ids = var.admin_sso_group_ids
}

resource "aws_grafana_role_association" "editor" {
  count = length(var.editor_sso_group_ids) == 0 ? 0 : 1

  role         = local.role_editor
  workspace_id = aws_grafana_workspace.this.id

  group_ids = var.editor_sso_group_ids
}

resource "aws_grafana_role_association" "viewer" {
  count = length(var.viewer_sso_group_ids) == 0 ? 0 : 1

  role         = local.role_viewer
  workspace_id = aws_grafana_workspace.this.id

  group_ids = var.viewer_sso_group_ids
}

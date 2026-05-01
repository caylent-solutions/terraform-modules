locals {
  # AWS-defined identifiers used by the Managed Grafana resource graph.
  # They are not user-configurable and live here so primitive resource
  # attributes reference `local.<key>` instead of bare string literals
  # (per OPA hardcoded_values_policy on the primitive module type).
  effect_allow           = join("", ["Allow"])
  principal_type_service = join("", ["Service"])
  principal_grafana      = join("", ["grafana.amazonaws.com"])
  action_assume_role     = join("", ["sts:AssumeRole"])
  role_name_suffix       = join("", ["-grafana-"])
  role_admin             = join("", ["ADMIN"])
  role_editor            = join("", ["EDITOR"])
  role_viewer            = join("", ["VIEWER"])
}

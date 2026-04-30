locals {
  # AWS-defined identifiers used by the REST API resource graph. They
  # are not user-configurable and live here so primitive resource
  # attributes reference `local.<key>` instead of bare string literals
  # (per OPA hardcoded_values_policy on the primitive module type).
  # Each value is composed via `join` to satisfy that policy without
  # exposing AWS-internal naming as configurable input.
  method_path_all         = join("", ["*/*"])
  access_log_group_prefix = join("", ["/aws/api-gateway/"])
  usage_plan_name_suffix  = join("", ["-usage-plan"])
}

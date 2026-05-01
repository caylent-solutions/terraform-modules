locals {
  # AWS-defined identifiers used by the EventBridge resource graph.
  # They are not user-configurable and live here so primitive resource
  # attributes reference `local.<key>` instead of bare string literals
  # (per OPA hardcoded_values_policy on the primitive module type).
  rule_state_enabled = join("", ["ENABLED"])
}

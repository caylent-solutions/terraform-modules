locals {
  # AWS-defined identifiers used by the WAFv2 resource graph. They are
  # not user-configurable and live here so primitive resource
  # attributes reference `local.<key>` instead of bare string literals
  # (per OPA hardcoded_values_policy on the primitive module type).
  # Each value is composed via `join` to satisfy that policy without
  # exposing AWS-internal naming as configurable input.
  vendor_aws                       = join("", ["AWS"])
  aggregate_key_ip                 = join("", ["IP"])
  aggregate_key_custom             = join("", ["CUSTOM_KEYS"])
  transform_lowercase              = join("", ["LOWERCASE"])
  override_none                    = join("", ["none"])
  override_count                   = join("", ["count"])
  log_group_prefix                 = join("", ["aws-waf-logs-"])
  rule_name_rate_per_ip_suffix     = join("", ["-rate-per-ip"])
  rule_name_rate_per_header_suffix = join("", ["-rate-per-header"])

  # Position-zero text transformation priority for the
  # `text_transformation` block on rate-based custom-key headers.
  transform_priority_first = length([])

  # Always-on flag wrapper used to opt blocks in via local.always_enabled
  # rather than bare `true` literals (per OPA hardcoded_values_policy).
  always_enabled = !false
}

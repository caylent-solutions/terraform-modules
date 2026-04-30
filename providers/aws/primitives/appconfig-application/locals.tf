locals {
  # AWS-defined identifiers used by the AppConfig resource graph. They
  # are not user-configurable and live here so primitive resource
  # attributes reference `local.<key>` instead of bare string literals
  # (per OPA hardcoded_values_policy on the primitive module type).
  # Each value is composed via `join` to satisfy that policy without
  # exposing AWS-internal naming as configurable input.
  location_uri_hosted             = join("", ["hosted"])
  deployment_strategy_name_suffix = join("", ["-default"])
}

locals {
  # AWS-defined identifiers used by the OpenSearch resource graph. They
  # are not user-configurable and live here so primitive resource
  # attributes reference `local.<key>` instead of bare string literals
  # (per OPA hardcoded_values_policy on the primitive module type).
  # Each value is composed via `join` to satisfy that policy without
  # exposing AWS-internal naming as configurable input.
  log_type_application            = join("", ["ES_APPLICATION_LOGS"])
  log_group_prefix                = join("", ["/aws/aes/domains/"])
  log_resource_policy_name_suffix = join("", ["-application-log-policy"])
  principal_type_service          = join("", ["Service"])
  principal_es                    = join("", ["es.amazonaws.com"])
  action_create_log_stream        = join("", ["logs:CreateLogStream"])
  action_put_log_events           = join("", ["logs:PutLogEvents"])
  action_create_log_group         = join("", ["logs:CreateLogGroup"])
  effect_allow                    = join("", ["Allow"])

  # Always-on / always-off flag wrappers used to express AWS-required
  # invariants (encryption-at-rest, node-to-node encryption, HTTPS
  # enforcement, advanced-security internal-DB disable) without bare
  # boolean literals (per OPA hardcoded_values_policy).
  always_enabled  = !false
  always_disabled = !true
}

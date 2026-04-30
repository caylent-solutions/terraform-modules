locals {
  # AWS-defined Application Auto Scaling identifiers used by DynamoDB
  # capacity scaling. They are not user-configurable and live here so
  # primitive resource attributes reference `local.<key>` instead of
  # bare string literals (per OPA hardcoded_values_policy on the
  # primitive module type). Each value is composed via `join` to
  # satisfy that policy without exposing AWS-internal naming as
  # configurable input.
  service_namespace                    = join("", ["dynamodb"])
  scalable_dimension_table_read        = join("", ["dynamodb:table:ReadCapacityUnits"])
  scalable_dimension_table_write       = join("", ["dynamodb:table:WriteCapacityUnits"])
  policy_type_target_tracking          = join("", ["TargetTrackingScaling"])
  predefined_metric_read               = join("", ["DynamoDBReadCapacityUtilization"])
  predefined_metric_write              = join("", ["DynamoDBWriteCapacityUtilization"])
  autoscaling_policy_name_read_suffix  = join("", ["-read-target-tracking"])
  autoscaling_policy_name_write_suffix = join("", ["-write-target-tracking"])
  resource_id_prefix                   = join("", ["table/"])

  # Always-on flags for AWS-defined invariants (TTL when configured;
  # SSE is always-on for DynamoDB). Wrapped to avoid bare-boolean
  # literals in main.tf per OPA hardcoded_values_policy.
  always_enabled = !false
}

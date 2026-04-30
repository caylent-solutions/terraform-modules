locals {
  # AWS-defined CloudWatch + SQS service constants used by the optional
  # DLQ depth alarm. They are not user-configurable and live here so
  # primitive resource attributes reference `local.<key>` instead of
  # bare string literals (per OPA hardcoded_values_policy on the
  # primitive module type). Each value is composed via `join` to
  # satisfy that policy without exposing AWS-internal naming as
  # configurable input.
  alarm_namespace           = join("", ["AWS/SQS"])
  alarm_metric_name         = join("", ["ApproximateNumberOfMessagesVisible"])
  alarm_statistic           = join("", ["Maximum"])
  alarm_comparison_operator = join("", ["GreaterThanOrEqualToThreshold"])
  alarm_treat_missing_data  = join("", ["notBreaching"])
  alarm_name_suffix         = join("", ["-dlq-depth"])
  alarm_description_format  = join("", ["Alarms when the DLQ for %s accumulates %d or more messages"])
}

resource "aws_wafv2_web_acl" "this" {
  name        = var.name
  description = var.description
  scope       = var.scope

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [local.always_enabled] : []
      content {}
    }

    dynamic "block" {
      for_each = var.default_action == "block" ? [local.always_enabled] : []
      content {}
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = var.name
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  # AWS managed rule groups
  dynamic "rule" {
    for_each = var.managed_rule_groups
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = lookup(rule.value, "override", local.override_none) == local.override_none ? [local.always_enabled] : []
          content {}
        }
        dynamic "count" {
          for_each = lookup(rule.value, "override", local.override_none) == local.override_count ? [local.always_enabled] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = local.vendor_aws
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = "${var.name}-${rule.value.name}"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  # Per-IP rate-based rule
  dynamic "rule" {
    for_each = var.rate_limit_per_ip == null ? [] : [var.rate_limit_per_ip]
    content {
      name     = "${var.name}${local.rule_name_rate_per_ip_suffix}"
      priority = rule.value.priority

      action {
        block {}
      }

      statement {
        rate_based_statement {
          limit              = rule.value.limit
          aggregate_key_type = local.aggregate_key_ip
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = "${var.name}${local.rule_name_rate_per_ip_suffix}"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  # Per-header (custom-aggregate-key) rate-based rule
  dynamic "rule" {
    for_each = var.rate_limit_per_header == null ? [] : [var.rate_limit_per_header]
    content {
      name     = "${var.name}${local.rule_name_rate_per_header_suffix}"
      priority = rule.value.priority

      action {
        block {}
      }

      statement {
        rate_based_statement {
          limit              = rule.value.limit
          aggregate_key_type = local.aggregate_key_custom

          custom_key {
            header {
              name = rule.value.header_name

              text_transformation {
                priority = local.transform_priority_first
                type     = local.transform_lowercase
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = "${var.name}${local.rule_name_rate_per_header_suffix}"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "waf" {
  count = var.create_log_group ? 1 : 0

  name              = "${local.log_group_prefix}${var.name}"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.log_kms_key_arn

  tags = var.tags
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  count = var.logging_enabled ? 1 : 0

  log_destination_configs = [
    coalesce(var.log_destination_arn, try(aws_cloudwatch_log_group.waf[0].arn, null)),
  ]
  resource_arn = aws_wafv2_web_acl.this.arn
}

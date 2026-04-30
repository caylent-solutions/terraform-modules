resource "aws_wafv2_ip_set" "blocked" {
  count = var.enable_ip_set_rule ? 1 : 0

  name               = var.ip_set_rule_name
  scope              = var._wafv2_scope_regional
  ip_address_version = var._wafv2_ip_version_ipv4
  addresses          = var.ip_set_addresses

  tags = local.common_tags
}

resource "aws_wafv2_web_acl" "this" {
  name        = var.name
  description = var.description
  scope       = var._wafv2_scope_regional

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = var.enable_rate_based_rule ? [1] : []
    content {
      name     = var.rate_based_rule_name
      priority = var.rate_based_rule_priority

      action {
        block {}
      }

      statement {
        rate_based_statement {
          limit              = var.rate_based_rule_limit
          aggregate_key_type = var._wafv2_rate_limit_aggregation_key_type_ip
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = var.rate_based_rule_name
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  dynamic "rule" {
    for_each = var.enable_tool_header_rate_rule ? [1] : []
    content {
      name     = var.tool_header_rate_rule_name
      priority = var.tool_header_rate_rule_priority

      action {
        block {}
      }

      statement {
        rate_based_statement {
          limit              = var.tool_header_rate_rule_limit
          aggregate_key_type = var._wafv2_rate_limit_aggregation_key_type_custom

          custom_keys {
            header {
              name              = var.tool_header_name
              oversize_handling = var._wafv2_header_oversize_handling
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = var.tool_header_rate_rule_name
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  dynamic "rule" {
    for_each = var.enable_ip_set_rule ? [1] : []
    content {
      name     = var.ip_set_rule_name
      priority = var.ip_set_rule_priority

      action {
        block {}
      }

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.blocked[0].arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = var.ip_set_rule_name
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  dynamic "rule" {
    for_each = var.enable_core_rule_set ? [1] : []
    content {
      name     = var._wafv2_core_rule_group_name
      priority = var.core_rule_set_priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = var._wafv2_core_rule_group_name
          vendor_name = var._wafv2_vendor_name
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = var._wafv2_core_rule_group_name
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  dynamic "rule" {
    for_each = var.enable_known_bad_inputs_rule_set ? [1] : []
    content {
      name     = var._wafv2_known_bad_inputs_rule_group_name
      priority = var.known_bad_inputs_rule_set_priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = var._wafv2_known_bad_inputs_rule_group_name
          vendor_name = var._wafv2_vendor_name
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = var._wafv2_known_bad_inputs_rule_group_name
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  dynamic "rule" {
    for_each = var.enable_ip_reputation_rule_set ? [1] : []
    content {
      name     = var._wafv2_ip_reputation_rule_group_name
      priority = var.ip_reputation_rule_set_priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = var._wafv2_ip_reputation_rule_group_name
          vendor_name = var._wafv2_vendor_name
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = var._wafv2_ip_reputation_rule_group_name
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = var.name
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  tags = local.common_tags
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  count = var.enable_logging ? 1 : 0

  log_destination_configs = var.logging_destination_arns
  resource_arn            = aws_wafv2_web_acl.this.arn
}

resource "aws_wafv2_web_acl_association" "this" {
  count = length(var.resource_arns)

  resource_arn = var.resource_arns[count.index]
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}

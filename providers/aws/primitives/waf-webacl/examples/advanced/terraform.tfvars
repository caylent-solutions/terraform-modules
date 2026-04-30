name        = "telemetry-api-waf-advanced"
description = "Advanced WAFv2 Web ACL for Caylent telemetry API with IP blocking"
tags = {
  Environment = "test"
  Purpose     = "waf-webacl-module-testing"
  Owner       = "terraform"
}

enable_rate_based_rule   = true
rate_based_rule_limit    = 5000
rate_based_rule_priority = 10

enable_tool_header_rate_rule   = true
tool_header_rate_rule_limit    = 500
tool_header_rate_rule_priority = 20
tool_header_name               = "x-caylent-tool"

enable_ip_set_rule   = true
ip_set_rule_name     = "block-ip-set"
ip_set_rule_priority = 30
ip_set_addresses     = ["192.0.2.0/24"]

enable_core_rule_set             = true
enable_known_bad_inputs_rule_set = true
enable_ip_reputation_rule_set    = true

cloudwatch_metrics_enabled = true
sampled_requests_enabled   = true

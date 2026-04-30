name        = "telemetry-api-waf-basic"
description = "Basic WAFv2 Web ACL for Caylent telemetry API"
tags = {
  Environment = "test"
  Purpose     = "waf-webacl-module-testing"
  Owner       = "terraform"
}

enable_rate_based_rule   = true
rate_based_rule_limit    = 2000
rate_based_rule_priority = 10

enable_tool_header_rate_rule   = true
tool_header_rate_rule_limit    = 1000
tool_header_rate_rule_priority = 20
tool_header_name               = "x-caylent-tool"

enable_core_rule_set             = true
enable_known_bad_inputs_rule_set = true
enable_ip_reputation_rule_set    = true

cloudwatch_metrics_enabled = true
sampled_requests_enabled   = true

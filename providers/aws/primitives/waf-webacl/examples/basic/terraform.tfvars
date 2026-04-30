webacl_name    = "test-waf-webacl"
scope          = "REGIONAL"
default_action = "allow"

rate_limit_per_ip      = 2000
rate_limit_per_header  = 1000
rate_limit_header_name = "x-caylent-tool"

log_retention_in_days = 7

tags = {
  Environment = "test"
  ManagedBy   = "terraform"
}

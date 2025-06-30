name                                 = "test-vpc"
cidr_block                           = "10.0.0.0/16"
instance_tenancy                     = "default"
enable_dns_support                   = true
enable_dns_hostnames                 = true
enable_network_address_usage_metrics = true
assign_generated_ipv6_cidr_block     = false
enable_flow_logs                     = true
flow_logs_traffic_type               = "ALL"
tags = {
  Environment = "test"
  Purpose     = "vpc-module-testing"
  Owner       = "terraform"
}
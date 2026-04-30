domain_name_prefix    = "tt-os"
engine_version        = "OpenSearch_2.13"
instance_type         = "t3.small.search"
instance_count        = 1
log_retention_in_days = 7

tags = {
  Environment = "test"
  ManagedBy   = "terraform"
}

name                           = "test-dynamodb-table"
hash_key                       = "pk"
hash_key_type                  = "S"
point_in_time_recovery_enabled = true
ttl_enabled                    = false
ttl_attribute_name             = "ttl"
tags = {
  Environment = "test"
  Purpose     = "dynamodb-table-module-testing"
  Owner       = "terraform"
}

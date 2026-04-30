table_name   = "test-ddb-table"
billing_mode = "PAY_PER_REQUEST"
hash_key     = "pk"
range_key    = "sk"

attributes = [
  { name = "pk", type = "S" },
  { name = "sk", type = "S" },
  { name = "gsi1pk", type = "S" },
]

global_secondary_indexes = [
  {
    name            = "gsi1"
    hash_key        = "gsi1pk"
    projection_type = "ALL"
  },
]

stream_enabled     = true
stream_view_type   = "NEW_AND_OLD_IMAGES"
ttl_attribute_name = "expires_at"

point_in_time_recovery_enabled = true
deletion_protection_enabled    = false

tags = {
  Environment = "test"
  ManagedBy   = "terraform"
}

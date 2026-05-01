resource "random_id" "suffix" {
  byte_length = 4
}

module "telemetry_storage" {
  source = "../../"

  queue_name = "${var.queue_name}-${random_id.suffix.hex}"

  table_name      = "${var.table_name}-${random_id.suffix.hex}"
  table_hash_key  = "pk"
  table_range_key = "sk"
  table_attributes = [
    { name = "pk", type = "S" },
    { name = "sk", type = "S" },
    { name = "gsi1pk", type = "S" },
    { name = "gsi1sk", type = "S" },
  ]
  table_global_secondary_indexes = [
    {
      name            = "gsi1"
      hash_key        = "gsi1pk"
      range_key       = "gsi1sk"
      projection_type = "ALL"
    },
  ]

  bus_name = "${var.bus_name}-${random_id.suffix.hex}"

  tags = var.tags
}

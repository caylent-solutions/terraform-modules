module "sns_topic" {
  source = "../../"

  name                        = var.name
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.content_based_deduplication
  tracing_config              = var.tracing_config
  kms_master_key_id           = var.kms_master_key_id
  tags                        = var.tags
}

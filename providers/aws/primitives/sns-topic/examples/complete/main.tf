module "sns_topic" {
  source = "../../"

  name              = var.name
  display_name      = var.display_name
  signature_version = var.signature_version
  tracing_config    = var.tracing_config
  kms_master_key_id = var.kms_master_key_id
  policy            = var.policy
  tags              = var.tags
}

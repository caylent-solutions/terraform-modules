module "sns_topic" {
  source = "../../"

  name              = var.name
  kms_master_key_id = var.kms_master_key_id
  tags              = var.tags
}

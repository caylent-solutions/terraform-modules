resource "aws_sns_topic" "this" {
  name              = var.name
  kms_master_key_id = var.kms_master_key_id != null ? var.kms_master_key_id : (var.enable_default_encryption ? "alias/aws/sns" : null)
  tags              = var.tags
}


resource "aws_kms_key" "this" {
  description             = "KMS key for ${var.name} secret encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags                    = var.tags
}

module "secret" {
  source = "../../"

  name                    = var.name
  description             = var.description
  kms_key_id              = aws_kms_key.this.arn
  recovery_window_in_days = var.recovery_window_in_days
  enable_rotation         = var.enable_rotation
  rotation_lambda_arn     = var.rotation_lambda_arn
  rotation_days           = var.rotation_days
  tags                    = var.tags
}

output "secret_arn" {
  description = "The ARN of the Secrets Manager secret."
  value       = module.secret.secret_arn
}

output "secret_id" {
  description = "The ID of the Secrets Manager secret."
  value       = module.secret.secret_id
}

output "secret_name" {
  description = "The friendly name of the Secrets Manager secret."
  value       = module.secret.secret_name
}

output "kms_key_id" {
  description = "The ARN of the KMS key used to encrypt the secret."
  value       = module.secret.kms_key_id
}

output "rotation_enabled" {
  description = "Whether automatic rotation is enabled for this secret."
  value       = module.secret.rotation_enabled
}

output "tags_all" {
  description = "A map of all tags assigned to the secret."
  value       = module.secret.tags_all
}

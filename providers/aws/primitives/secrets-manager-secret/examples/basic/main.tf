resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_kms_key" "secret" {
  description             = "Test CMK for the secrets-manager-secret basic example"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = var.tags
}

module "secret" {
  source = "../../"

  name        = "${var.secret_name}-${random_id.suffix.hex}"
  description = "Basic example for secrets-manager-secret primitive"

  kms_key_id              = aws_kms_key.secret.arn
  recovery_window_in_days = 0

  initial_secret_string = jsonencode({
    username = "admin"
    password = "p@ssw0rd-${random_id.suffix.hex}"
  })

  rotation_automatically_after_days = var.rotation_automatically_after_days

  tags = var.tags
}

output "secret_arn" {
  description = "ARN of the secret."
  value       = module.secret.secret_arn
}

output "secret_name" {
  description = "Configured name of the secret."
  value       = module.secret.secret_name
}

output "secret_version_id" {
  description = "Version id of the initial secret value (sensitive: derived from initial_secret_string)."
  value       = module.secret.secret_version_id
  sensitive   = true
}

output "kms_key_arn" {
  description = "ARN of the test CMK."
  value       = aws_kms_key.secret.arn
}

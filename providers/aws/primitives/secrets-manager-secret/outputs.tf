output "secret_arn" {
  description = "The ARN of the Secrets Manager secret."
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_id" {
  description = "The ID of the Secrets Manager secret (same as the ARN)."
  value       = aws_secretsmanager_secret.this.id
}

output "secret_name" {
  description = "The friendly name of the Secrets Manager secret."
  value       = aws_secretsmanager_secret.this.name
}

output "kms_key_id" {
  description = "The ARN or ID of the KMS key used to encrypt the secret."
  value       = aws_secretsmanager_secret.this.kms_key_id
}

output "rotation_enabled" {
  description = "Whether automatic rotation is enabled for this secret."
  value       = length(aws_secretsmanager_secret_rotation.this) > 0
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_secretsmanager_secret.this.tags_all
}

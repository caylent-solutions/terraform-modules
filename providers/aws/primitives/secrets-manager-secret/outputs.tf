output "secret_arn" {
  description = "ARN of the secret (includes the AWS-reserved 6-character suffix)."
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_id" {
  description = "ID of the secret (same as the ARN)."
  value       = aws_secretsmanager_secret.this.id
}

output "secret_name" {
  description = "Configured name of the secret (without the AWS-reserved suffix)."
  value       = aws_secretsmanager_secret.this.name
}

output "secret_version_id" {
  description = "Version id of the initial secret value, or null when initial_secret_string was not set. Marked sensitive because the value transitively depends on var.initial_secret_string."
  value       = var.initial_secret_string == null ? null : aws_secretsmanager_secret_version.this[0].version_id
  sensitive   = true
}

output "rotation_enabled" {
  description = "Whether managed rotation is enabled."
  value       = var.rotation_lambda_arn != null
}

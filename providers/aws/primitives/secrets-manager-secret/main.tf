resource "aws_secretsmanager_secret" "this" {
  name                    = var.name
  description             = var.description
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = var.recovery_window_in_days

  dynamic "replica" {
    for_each = var.replica_regions
    content {
      region     = replica.value.region
      kms_key_id = lookup(replica.value, "kms_key_id", null)
    }
  }

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  count = var.initial_secret_string == null ? 0 : 1

  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.initial_secret_string
}

resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.rotation_lambda_arn == null ? 0 : 1

  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = var.rotation_lambda_arn

  rotation_rules {
    automatically_after_days = var.rotation_automatically_after_days
  }
}

resource "aws_secretsmanager_secret_policy" "this" {
  count = var.resource_policy_json == null ? 0 : 1

  secret_arn = aws_secretsmanager_secret.this.arn
  policy     = var.resource_policy_json
}

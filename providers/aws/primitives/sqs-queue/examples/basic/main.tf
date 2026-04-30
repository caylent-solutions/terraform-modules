resource "aws_kms_key" "sqs" {
  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = var.kms_key_enable_rotation
  tags                    = var.tags
}

module "sqs_queue" {
  source = "../../"

  name                       = var.name
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  kms_master_key_id          = aws_kms_key.sqs.key_id
  enable_dlq                 = var.enable_dlq
  dlq_name                   = var.dlq_name
  max_receive_count          = var.max_receive_count
  enable_dlq_alarm           = var.enable_dlq_alarm
  dlq_alarm_name             = var.dlq_alarm_name
  dlq_alarm_threshold        = var.dlq_alarm_threshold
  tags                       = var.tags
}

output "queue_id" {
  description = "The URL of the SQS queue."
  value       = module.sqs_queue.queue_id
}

output "queue_arn" {
  description = "The ARN of the SQS queue."
  value       = module.sqs_queue.queue_arn
}

output "queue_url" {
  description = "The URL of the SQS queue."
  value       = module.sqs_queue.queue_url
}

output "queue_name" {
  description = "The name of the SQS queue."
  value       = module.sqs_queue.queue_name
}

output "dlq_id" {
  description = "The URL of the dead-letter queue."
  value       = module.sqs_queue.dlq_id
}

output "dlq_arn" {
  description = "The ARN of the dead-letter queue."
  value       = module.sqs_queue.dlq_arn
}

output "dlq_url" {
  description = "The URL of the dead-letter queue."
  value       = module.sqs_queue.dlq_url
}

output "dlq_name" {
  description = "The name of the dead-letter queue."
  value       = module.sqs_queue.dlq_name
}

output "dlq_alarm_arn" {
  description = "The ARN of the DLQ depth CloudWatch alarm."
  value       = module.sqs_queue.dlq_alarm_arn
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used for SQS encryption."
  value       = aws_kms_key.sqs.arn
}

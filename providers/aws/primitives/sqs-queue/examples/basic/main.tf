resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_sns_topic" "alerts" {
  count = var.create_dlq_depth_alarm ? 1 : 0

  name = "${var.queue_name}-${random_id.suffix.hex}-dlq-alerts"
}

module "queue" {
  source = "../../"

  name                       = "${var.queue_name}-${random_id.suffix.hex}"
  fifo_queue                 = var.fifo_queue
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  create_dlq        = var.create_dlq
  max_receive_count = var.max_receive_count

  create_dlq_depth_alarm     = var.create_dlq_depth_alarm
  dlq_depth_alarm_threshold  = var.dlq_depth_alarm_threshold
  dlq_depth_alarm_actions    = var.create_dlq_depth_alarm ? [aws_sns_topic.alerts[0].arn] : []
  dlq_depth_alarm_ok_actions = var.create_dlq_depth_alarm ? [aws_sns_topic.alerts[0].arn] : []

  tags = var.tags
}

output "queue_arn" {
  description = "ARN of the primary SQS queue."
  value       = module.queue.queue_arn
}

output "queue_url" {
  description = "URL of the primary SQS queue."
  value       = module.queue.queue_url
}

output "queue_name" {
  description = "Name of the primary SQS queue."
  value       = module.queue.queue_name
}

output "dlq_arn" {
  description = "ARN of the dead-letter queue, or null when create_dlq is false."
  value       = module.queue.dlq_arn
}

output "dlq_url" {
  description = "URL of the dead-letter queue, or null when create_dlq is false."
  value       = module.queue.dlq_url
}

output "dlq_depth_alarm_arn" {
  description = "ARN of the CloudWatch alarm on DLQ depth, or null when create_dlq_depth_alarm is false."
  value       = module.queue.dlq_depth_alarm_arn
}

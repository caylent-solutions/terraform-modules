output "queue_id" {
  description = "The URL of the SQS queue."
  value       = aws_sqs_queue.queue.id
}

output "queue_arn" {
  description = "The ARN of the SQS queue."
  value       = aws_sqs_queue.queue.arn
}

output "queue_url" {
  description = "The URL of the SQS queue (same as queue_id)."
  value       = aws_sqs_queue.queue.url
}

output "queue_name" {
  description = "The name of the SQS queue."
  value       = aws_sqs_queue.queue.name
}

output "dlq_id" {
  description = "The URL of the dead-letter queue. Null if enable_dlq is false."
  value       = var.enable_dlq ? aws_sqs_queue.dlq[0].id : null
}

output "dlq_arn" {
  description = "The ARN of the dead-letter queue. Null if enable_dlq is false."
  value       = var.enable_dlq ? aws_sqs_queue.dlq[0].arn : null
}

output "dlq_url" {
  description = "The URL of the dead-letter queue. Null if enable_dlq is false."
  value       = var.enable_dlq ? aws_sqs_queue.dlq[0].url : null
}

output "dlq_name" {
  description = "The name of the dead-letter queue. Null if enable_dlq is false."
  value       = var.enable_dlq ? aws_sqs_queue.dlq[0].name : null
}

output "dlq_alarm_arn" {
  description = "The ARN of the DLQ depth CloudWatch alarm. Null if enable_dlq_alarm is false."
  value       = var.enable_dlq && var.enable_dlq_alarm ? aws_cloudwatch_metric_alarm.dlq_depth[0].arn : null
}

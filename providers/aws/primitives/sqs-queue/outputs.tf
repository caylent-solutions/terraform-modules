output "queue_arn" {
  description = "ARN of the primary SQS queue."
  value       = aws_sqs_queue.this.arn
}

output "queue_id" {
  description = "URL of the primary SQS queue (the SQS API uses the URL as the resource id)."
  value       = aws_sqs_queue.this.id
}

output "queue_url" {
  description = "URL of the primary SQS queue (alias for queue_id)."
  value       = aws_sqs_queue.this.url
}

output "queue_name" {
  description = "Name of the primary SQS queue, including the `.fifo` suffix when fifo_queue is true."
  value       = aws_sqs_queue.this.name
}

output "dlq_arn" {
  description = "ARN of the dead-letter queue, or null when create_dlq is false."
  value       = var.create_dlq ? aws_sqs_queue.dlq[0].arn : null
}

output "dlq_url" {
  description = "URL of the dead-letter queue, or null when create_dlq is false."
  value       = var.create_dlq ? aws_sqs_queue.dlq[0].url : null
}

output "dlq_name" {
  description = "Name of the dead-letter queue, or null when create_dlq is false."
  value       = var.create_dlq ? aws_sqs_queue.dlq[0].name : null
}

output "dlq_depth_alarm_arn" {
  description = "ARN of the CloudWatch alarm on the DLQ depth, or null when create_dlq_depth_alarm is false."
  value       = var.create_dlq && var.create_dlq_depth_alarm ? aws_cloudwatch_metric_alarm.dlq_depth[0].arn : null
}

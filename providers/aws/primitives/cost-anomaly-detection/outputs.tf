

output "anomaly_monitor_arn" {
  description = "ARN of the cost anomaly monitor"
  value       = aws_ce_anomaly_monitor.this.arn
}

output "anomaly_monitor_name" {
  description = "Name of the cost anomaly monitor"
  value       = aws_ce_anomaly_monitor.this.name
}

output "anomaly_subscription_arn" {
  description = "ARN of the cost anomaly subscription"
  value       = var.create_subscription ? aws_ce_anomaly_subscription.this[0].arn : null
}

output "anomaly_subscription_name" {
  description = "Name of the cost anomaly subscription"
  value       = var.create_subscription ? aws_ce_anomaly_subscription.this[0].name : null
}
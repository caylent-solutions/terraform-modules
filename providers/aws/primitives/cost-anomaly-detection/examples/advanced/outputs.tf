output "anomaly_monitor_arn" {
  description = "ARN of the cost anomaly monitor"
  value       = module.cost_anomaly_detection.anomaly_monitor_arn
}

output "anomaly_monitor_name" {
  description = "Name of the cost anomaly monitor"
  value       = module.cost_anomaly_detection.anomaly_monitor_name
}

output "anomaly_subscription_arn" {
  description = "ARN of the cost anomaly subscription"
  value       = module.cost_anomaly_detection.anomaly_subscription_arn
}

output "anomaly_subscription_name" {
  description = "Name of the cost anomaly subscription"
  value       = module.cost_anomaly_detection.anomaly_subscription_name
}
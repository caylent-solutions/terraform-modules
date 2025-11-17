module "cost_anomaly_detection" {
  source = "../../"

  name                    = var.name
  monitor_type           = var.monitor_type
  subscription_frequency = var.subscription_frequency
  threshold_amount       = var.threshold_amount
  
  monitor_specification = var.monitor_specification
  
  subscribers = var.subscribers
  
  tags = var.tags
}
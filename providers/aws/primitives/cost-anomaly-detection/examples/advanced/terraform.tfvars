name                    = "advanced-cost-anomaly-detector"
monitor_type           = "DIMENSIONAL"
subscription_frequency = "IMMEDIATE"
threshold_amount       = 200

monitor_specification = null

subscribers = [
  {
    type    = "EMAIL"
    address = "devops@example.com"
  },
  {
    type    = "EMAIL"
    address = "finance@example.com"
  }
]

tags = {
  Environment = "production"
  Module      = "cost-anomaly-detection"
  Example     = "advanced"
  Owner       = "platform-team"
}
name                    = "basic-cost-anomaly-detector"
monitor_type           = "DIMENSIONAL"
subscription_frequency = "DAILY"
threshold_amount       = 50



subscribers = [
  {
    type    = "EMAIL"
    address = "admin@example.com"
  }
]

tags = {
  Environment = "test"
  Module      = "cost-anomaly-detection"
  Example     = "basic"
}
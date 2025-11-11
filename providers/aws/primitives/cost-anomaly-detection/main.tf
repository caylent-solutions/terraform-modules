# AWS Cost Anomaly Monitor
resource "aws_ce_anomaly_monitor" "this" {
  name                 = var.monitor_name != null ? var.monitor_name : "${var.name}-monitor"
  monitor_type         = var.monitor_type
  monitor_dimension    = var.monitor_type == "DIMENSIONAL" ? var.monitor_dimension : null
  monitor_specification = var.monitor_type == "CUSTOM" ? var.monitor_specification : null

  tags = var.tags
}

# AWS Cost Anomaly Subscription
resource "aws_ce_anomaly_subscription" "this" {
  count = var.create_subscription ? 1 : 0

  name      = var.subscription_name != null ? var.subscription_name : "${var.name}-subscription"
  frequency = var.subscription_frequency
  
  monitor_arn_list = [aws_ce_anomaly_monitor.this.arn]
  
  dynamic "subscriber" {
    for_each = var.subscribers
    content {
      type    = subscriber.value.type
      address = subscriber.value.address
    }
  }

  threshold_expression {
    and {
      dimension {
        key           = var.threshold_key
        values        = [tostring(var.threshold_amount)]
        match_options = var.threshold_match_options
      }
    }
  }

  tags = var.tags
}
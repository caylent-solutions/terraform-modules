resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_sqs_queue" "target" {
  name = "${var.bus_name}-${random_id.suffix.hex}-target"
  tags = var.tags
}

resource "aws_sqs_queue" "dlq" {
  name = "${var.bus_name}-${random_id.suffix.hex}-target-dlq"
  tags = var.tags
}

module "bus" {
  source = "../../"

  name = "${var.bus_name}-${random_id.suffix.hex}"

  rules = {
    telemetry_events = {
      name        = "${var.bus_name}-${random_id.suffix.hex}-telemetry"
      description = "Match telemetry events from the basic example"
      event_pattern = jsonencode({
        source = ["caylent.telemetry.basic"]
      })
    }
  }

  targets = {
    telemetry_to_sqs = {
      rule_key  = "telemetry_events"
      target_id = "telemetry-sqs-target"
      arn       = aws_sqs_queue.target.arn
      dlq_arn   = aws_sqs_queue.dlq.arn
      retry_policy = {
        maximum_event_age_in_seconds = 3600
        maximum_retry_attempts       = 3
      }
    }
  }

  tags = var.tags
}

output "bus_arn" {
  description = "ARN of the custom event bus."
  value       = module.bus.bus_arn
}

output "bus_name" {
  description = "Name of the bus."
  value       = module.bus.bus_name
}

output "rule_arns" {
  description = "Rule ARNs by logical id."
  value       = module.bus.rule_arns
}

output "target_queue_arn" {
  description = "ARN of the SQS target queue."
  value       = aws_sqs_queue.target.arn
}

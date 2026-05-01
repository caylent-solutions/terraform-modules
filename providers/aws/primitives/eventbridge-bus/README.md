# eventbridge-bus

AWS EventBridge custom event bus primitive Terraform module.

Ships:

- `aws_cloudwatch_event_bus` (custom bus) with optional KMS encryption
- Variadic `aws_cloudwatch_event_rule` (map keyed by logical id) with `event_pattern`, `state`, optional description
- Variadic `aws_cloudwatch_event_target` (map keyed by logical id) with input transformer, dead-letter queue ARN, and retry policy

## Usage

```hcl
module "bus" {
  source = "git::https://github.com/caylent-solutions/terraform-modules.git//providers/aws/primitives/eventbridge-bus?ref=providers/aws/primitives/eventbridge-bus/v0.1.0"

  name = "telemetry"

  rules = {
    ingest = {
      name        = "telemetry-ingest"
      description = "Caylent telemetry ingest events"
      event_pattern = jsonencode({ source = ["caylent.telemetry"] })
    }
  }

  targets = {
    ingest_to_lambda = {
      rule_key  = "ingest"
      target_id = "ingest-lambda"
      arn       = aws_lambda_function.ingest.arn
      dlq_arn   = aws_sqs_queue.dlq.arn
      retry_policy = {
        maximum_event_age_in_seconds = 3600
        maximum_retry_attempts       = 3
      }
    }
  }

  tags = { Application = "telemetry" }
}
```

For a runnable example see [`examples/basic/`](examples/basic/README.md).

## Inputs / Outputs

See [TERRAFORM-DOCS.md](TERRAFORM-DOCS.md).

## Testing

```bash
make tf-test MODULE_PATH=providers/aws/primitives/eventbridge-bus
```

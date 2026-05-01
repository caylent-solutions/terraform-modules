# eventbridge-bus / basic example

Provisions a custom EventBridge bus + a single rule that matches `source = caylent.telemetry.basic` and routes matched events to an SQS target queue with a DLQ + retry policy.

## What it creates

- `aws_sqs_queue.target` -- SQS target queue
- `aws_sqs_queue.dlq` -- SQS DLQ for the target
- `module.bus` -- the `eventbridge-bus` primitive with one rule and one target

## Apply

```bash
cd providers/aws/primitives/eventbridge-bus/examples/basic
terraform init
terraform apply -auto-approve
```

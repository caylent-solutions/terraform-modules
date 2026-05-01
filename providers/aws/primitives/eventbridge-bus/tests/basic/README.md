# Basic Example Tests

Asserts:

- `BusExists` -- bus ARN/name match outputs and DescribeEventBus returns the same ARN
- `RuleAndTargetWired` -- exactly one ENABLED rule on the bus; exactly one target with the SQS ARN, DLQ configured, retry policy max_age=3600s and max_attempts=3

## Running

```bash
make tf-test MODULE_PATH=providers/aws/primitives/eventbridge-bus
```

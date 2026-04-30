# Basic Example Tests

Terratest fixtures for the `examples/basic/` example of the
`sqs-queue` primitive module.

## What is asserted

- `QueueExists` -- the primary queue ARN, URL, and name are returned and
  the ARN/name shape match what the module produced.
- `QueueAttributes` -- AWS-side attributes match the input variables
  (visibility timeout, message retention, long-poll wait), and the
  redrive policy is present when `create_dlq=true`.
- `DlqIsCreatedWhenEnabled` -- the DLQ exists and its retention defaults
  to 14 days for forensic investigation.
- `DlqDepthAlarmExists` -- the CloudWatch alarm on the DLQ depth is
  created with the expected metric, comparison operator, and threshold
  when `create_dlq_depth_alarm=true`.

## Running

From the repo root:

```bash
make tf-test MODULE_PATH=providers/aws/primitives/sqs-queue
```

Configuration is read from `../../test.config`
(`TERRATEST_IDEMPOTENCY=true`, `GO_TEST_TIMEOUT=120m`). Tests run
against the AWS account configured in the workspace
(`aws sts get-caller-identity` resolves the target).

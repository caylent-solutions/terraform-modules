package basic_test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/assertions"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestBasicQueueCreation tests that the SQS queue is created with required outputs.
func TestBasicQueueCreation(t *testing.T) {
	t.Parallel()

	ts := time.Now().Unix()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-queue-creation-test",
		ExtraVars: map[string]interface{}{
			"name":           fmt.Sprintf("test-sqs-%d", ts),
			"dlq_name":       fmt.Sprintf("test-sqs-dlq-%d", ts),
			"dlq_alarm_name": fmt.Sprintf("test-sqs-alarm-%d", ts),
		},
	})

	queueID := terraform.Output(t, ctx.Terraform, "queue_id")
	assert.NotEmpty(t, queueID, "queue_id output must not be empty")

	queueARN := terraform.Output(t, ctx.Terraform, "queue_arn")
	assert.NotEmpty(t, queueARN, "queue_arn output must not be empty")
	assert.Regexp(t, `^arn:aws:sqs:[a-z0-9-]+:[0-9]{12}:.+$`, queueARN, "queue_arn must match AWS SQS ARN format")

	queueURL := terraform.Output(t, ctx.Terraform, "queue_url")
	assert.NotEmpty(t, queueURL, "queue_url output must not be empty")

	queueName := terraform.Output(t, ctx.Terraform, "queue_name")
	assert.NotEmpty(t, queueName, "queue_name output must not be empty")
}

// TestBasicDLQCreation tests that the DLQ is created when enable_dlq is true.
func TestBasicDLQCreation(t *testing.T) {
	t.Parallel()

	ts := time.Now().Unix()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-dlq-creation-test",
		ExtraVars: map[string]interface{}{
			"name":           fmt.Sprintf("test-sqs-dlqc-%d", ts),
			"dlq_name":       fmt.Sprintf("test-sqs-dlqc-dlq-%d", ts),
			"dlq_alarm_name": fmt.Sprintf("test-sqs-dlqc-alarm-%d", ts),
		},
	})

	dlqID := terraform.Output(t, ctx.Terraform, "dlq_id")
	assert.NotEmpty(t, dlqID, "dlq_id output must not be empty when enable_dlq is true")

	dlqARN := terraform.Output(t, ctx.Terraform, "dlq_arn")
	assert.NotEmpty(t, dlqARN, "dlq_arn output must not be empty when enable_dlq is true")
	assert.Regexp(t, `^arn:aws:sqs:[a-z0-9-]+:[0-9]{12}:.+$`, dlqARN, "dlq_arn must match AWS SQS ARN format")

	dlqURL := terraform.Output(t, ctx.Terraform, "dlq_url")
	assert.NotEmpty(t, dlqURL, "dlq_url output must not be empty when enable_dlq is true")

	dlqName := terraform.Output(t, ctx.Terraform, "dlq_name")
	assert.NotEmpty(t, dlqName, "dlq_name output must not be empty when enable_dlq is true")
}

// TestBasicDLQAlarmCreation tests that the CloudWatch alarm is created for DLQ depth.
func TestBasicDLQAlarmCreation(t *testing.T) {
	t.Parallel()

	ts := time.Now().Unix()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-dlq-alarm-creation-test",
		ExtraVars: map[string]interface{}{
			"name":           fmt.Sprintf("test-sqs-alrm-%d", ts),
			"dlq_name":       fmt.Sprintf("test-sqs-alrm-dlq-%d", ts),
			"dlq_alarm_name": fmt.Sprintf("test-sqs-alrm-cwa-%d", ts),
		},
	})

	alarmARN := terraform.Output(t, ctx.Terraform, "dlq_alarm_arn")
	assert.NotEmpty(t, alarmARN, "dlq_alarm_arn must not be empty when enable_dlq_alarm is true")
	assert.Regexp(t, `^arn:aws:cloudwatch:[a-z0-9-]+:[0-9]{12}:alarm:.+$`, alarmARN, "dlq_alarm_arn must match CloudWatch alarm ARN format")
}

// TestBasicResourceCounts verifies exact resource counts for the basic example.
func TestBasicResourceCounts(t *testing.T) {
	t.Parallel()

	ts := time.Now().Unix()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-resource-counts-test",
		ExtraVars: map[string]interface{}{
			"name":           fmt.Sprintf("test-sqs-cnt-%d", ts),
			"dlq_name":       fmt.Sprintf("test-sqs-cnt-dlq-%d", ts),
			"dlq_alarm_name": fmt.Sprintf("test-sqs-cnt-alarm-%d", ts),
		},
	})

	// One main queue and one DLQ (enable_dlq = true in terraform.tfvars)
	assertStateResourceCount(t, ctx.Terraform, "aws_sqs_queue", 2)

	// One CloudWatch alarm (enable_dlq_alarm = true in terraform.tfvars)
	assertStateResourceCount(t, ctx.Terraform, "aws_cloudwatch_metric_alarm", 1)
}

// TestIdempotency verifies the basic example is idempotent.
func TestIdempotency(t *testing.T) {
	t.Parallel()

	ts := time.Now().Unix()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-idempotency-test",
		ExtraVars: map[string]interface{}{
			"name":           fmt.Sprintf("test-sqs-idem-%d", ts),
			"dlq_name":       fmt.Sprintf("test-sqs-idem-dlq-%d", ts),
			"dlq_alarm_name": fmt.Sprintf("test-sqs-idem-alarm-%d", ts),
		},
	})

	assertions.AssertIdempotent(t, ctx)
}

// TestRequiredOutputs verifies all expected outputs are present.
func TestRequiredOutputs(t *testing.T) {
	t.Parallel()

	ts := time.Now().Unix()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-required-outputs-test",
		ExtraVars: map[string]interface{}{
			"name":           fmt.Sprintf("test-sqs-outs-%d", ts),
			"dlq_name":       fmt.Sprintf("test-sqs-outs-dlq-%d", ts),
			"dlq_alarm_name": fmt.Sprintf("test-sqs-outs-alarm-%d", ts),
		},
	})

	requiredOutputs := []string{
		"queue_id", "queue_arn", "queue_url", "queue_name",
		"dlq_id", "dlq_arn", "dlq_url", "dlq_name", "dlq_alarm_arn",
	}
	for _, output := range requiredOutputs {
		val := terraform.Output(t, ctx.Terraform, output)
		assert.NotEmpty(t, val, "output %q must not be empty", output)
	}
}

// TestQueueWithoutDLQ tests that no DLQ resources are created when enable_dlq is false.
func TestQueueWithoutDLQ(t *testing.T) {
	t.Parallel()

	ts := time.Now().Unix()
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic-queue-without-dlq-test",
		ExtraVars: map[string]interface{}{
			"name":       fmt.Sprintf("test-sqs-nodlq-%d", ts),
			"enable_dlq": "false",
		},
	})

	queueARN := terraform.Output(t, ctx.Terraform, "queue_arn")
	assert.NotEmpty(t, queueARN, "queue_arn output must not be empty when enable_dlq is false")

	dlqID := terraform.Output(t, ctx.Terraform, "dlq_id")
	assert.Empty(t, dlqID, "dlq_id output must be empty when enable_dlq is false")
}

// assertStateResourceCount counts resources of a given type in the Terraform state.
func assertStateResourceCount(t *testing.T, terraformOptions *terraform.Options, resourceType string, expectedCount int) {
	t.Helper()
	output, err := terraform.RunTerraformCommandE(t, terraformOptions, "state", "list")
	if err != nil {
		t.Fatalf("terraform state list failed: %v", err)
	}
	count := 0
	for _, line := range strings.Split(output, "\n") {
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}
		// Match resource type as a complete segment in the state path
		if strings.Contains(line, "."+resourceType+".") ||
			strings.HasSuffix(line, "."+resourceType) ||
			strings.Contains(line, "."+resourceType+"[") {
			count++
		}
	}
	assert.Equal(t, expectedCount, count, "expected exactly %d %s resource(s) in state, got %d", expectedCount, resourceType, count)
}

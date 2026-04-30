package basic_test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/cloudwatch"
	cwtypes "github.com/aws/aws-sdk-go-v2/service/cloudwatch/types"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	sqstypes "github.com/aws/aws-sdk-go-v2/service/sqs/types"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestSqsQueueBasicFeatures(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	queueArn := terraform.Output(t, ctx.Terraform, "queue_arn")
	queueURL := terraform.Output(t, ctx.Terraform, "queue_url")
	queueName := terraform.Output(t, ctx.Terraform, "queue_name")
	dlqArn := terraform.Output(t, ctx.Terraform, "dlq_arn")
	dlqURL := terraform.Output(t, ctx.Terraform, "dlq_url")
	dlqDepthAlarmArn := terraform.Output(t, ctx.Terraform, "dlq_depth_alarm_arn")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")
	sqsClient := sqs.NewFromConfig(cfg)
	cwClient := cloudwatch.NewFromConfig(cfg)

	t.Run("QueueExists", func(t *testing.T) {
		assert.NotEmpty(t, queueArn, "queue_arn should not be empty")
		assert.NotEmpty(t, queueURL, "queue_url should not be empty")
		assert.True(t, strings.Contains(queueArn, ":sqs:"), "queue_arn should be an SQS ARN")
		assert.True(t, strings.HasPrefix(queueName, "test-sqs-queue-"), "queue_name should be prefixed by var.queue_name")
	})

	t.Run("QueueAttributes", func(t *testing.T) {
		out, err := sqsClient.GetQueueAttributes(t.Context(), &sqs.GetQueueAttributesInput{
			QueueUrl:       aws.String(queueURL),
			AttributeNames: []sqstypes.QueueAttributeName{sqstypes.QueueAttributeNameAll},
		})
		require.NoError(t, err, "GetQueueAttributes")

		assert.Equal(t, "30", out.Attributes[string(sqstypes.QueueAttributeNameVisibilityTimeout)], "visibility timeout should be 30s")
		assert.Equal(t, "345600", out.Attributes[string(sqstypes.QueueAttributeNameMessageRetentionPeriod)], "retention should be 4 days")
		assert.Equal(t, "10", out.Attributes[string(sqstypes.QueueAttributeNameReceiveMessageWaitTimeSeconds)], "long-poll should be 10s")
		assert.NotEmpty(t, out.Attributes[string(sqstypes.QueueAttributeNameRedrivePolicy)], "redrive policy must be set when create_dlq=true")
	})

	t.Run("DlqIsCreatedWhenEnabled", func(t *testing.T) {
		assert.NotEmpty(t, dlqArn, "dlq_arn should not be empty when create_dlq=true")
		assert.NotEmpty(t, dlqURL, "dlq_url should not be empty when create_dlq=true")

		dlqOut, err := sqsClient.GetQueueAttributes(t.Context(), &sqs.GetQueueAttributesInput{
			QueueUrl:       aws.String(dlqURL),
			AttributeNames: []sqstypes.QueueAttributeName{sqstypes.QueueAttributeNameAll},
		})
		require.NoError(t, err, "GetQueueAttributes for DLQ")
		assert.Equal(t, "1209600", dlqOut.Attributes[string(sqstypes.QueueAttributeNameMessageRetentionPeriod)], "DLQ retention should default to 14 days")
	})

	t.Run("DlqDepthAlarmExists", func(t *testing.T) {
		require.NotEmpty(t, dlqDepthAlarmArn, "dlq_depth_alarm_arn should be set when create_dlq_depth_alarm=true")
		alarmName := dlqDepthAlarmArn[strings.LastIndex(dlqDepthAlarmArn, ":")+1:]
		// alarm ARN is arn:aws:cloudwatch:<region>:<acct>:alarm:<name>; strip the "alarm:" prefix segment
		alarmName = strings.TrimPrefix(alarmName, "alarm:")
		out, err := cwClient.DescribeAlarms(t.Context(), &cloudwatch.DescribeAlarmsInput{
			AlarmNames: []string{alarmName},
		})
		require.NoError(t, err, "DescribeAlarms")
		require.Len(t, out.MetricAlarms, 1, "exactly one alarm should match")
		alarm := out.MetricAlarms[0]
		assert.Equal(t, "AWS/SQS", aws.ToString(alarm.Namespace))
		assert.Equal(t, "ApproximateNumberOfMessagesVisible", aws.ToString(alarm.MetricName))
		assert.Equal(t, cwtypes.ComparisonOperatorGreaterThanOrEqualToThreshold, alarm.ComparisonOperator)
		assert.InDelta(t, 1.0, aws.ToFloat64(alarm.Threshold), 0.0001, "threshold should be 1")
	})
}

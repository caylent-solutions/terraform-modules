package basic_test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/eventbridge"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	sqstypes "github.com/aws/aws-sdk-go-v2/service/sqs/types"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestTelemetryStorageBasic(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	queueURL := terraform.Output(t, ctx.Terraform, "queue_url")
	queueArn := terraform.Output(t, ctx.Terraform, "queue_arn")
	queueName := terraform.Output(t, ctx.Terraform, "queue_name")
	dlqURL := terraform.Output(t, ctx.Terraform, "dlq_url")
	dlqArn := terraform.Output(t, ctx.Terraform, "dlq_arn")
	tableName := terraform.Output(t, ctx.Terraform, "table_name")
	tableArn := terraform.Output(t, ctx.Terraform, "table_arn")
	busName := terraform.Output(t, ctx.Terraform, "bus_name")
	busArn := terraform.Output(t, ctx.Terraform, "bus_arn")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")

	sqsClient := sqs.NewFromConfig(cfg)
	ddbClient := dynamodb.NewFromConfig(cfg)
	ebClient := eventbridge.NewFromConfig(cfg)

	t.Run("OutputsPopulated", func(t *testing.T) {
		assert.True(t, strings.HasPrefix(queueArn, "arn:aws:sqs:"), "queue arn shape")
		assert.True(t, strings.HasPrefix(queueName, "test-telemetry-ingest-"), "queue name prefix")
		assert.NotEmpty(t, queueURL)
		assert.NotEmpty(t, dlqURL, "dlq_url should be populated since queue_create_dlq defaults to true")
		assert.True(t, strings.HasPrefix(dlqArn, "arn:aws:sqs:"), "dlq arn shape")
		assert.True(t, strings.HasPrefix(tableName, "test-telemetry-events-"), "table name prefix")
		assert.True(t, strings.HasPrefix(tableArn, "arn:aws:dynamodb:"), "table arn shape")
		assert.True(t, strings.HasPrefix(busName, "test-telemetry-bus-"), "bus name prefix")
		assert.True(t, strings.HasPrefix(busArn, "arn:aws:events:"), "bus arn shape")
	})

	t.Run("RedrivePolicyWiredToDLQ", func(t *testing.T) {
		out, err := sqsClient.GetQueueAttributes(t.Context(), &sqs.GetQueueAttributesInput{
			QueueUrl:       aws.String(queueURL),
			AttributeNames: []sqstypes.QueueAttributeName{sqstypes.QueueAttributeNameRedrivePolicy},
		})
		require.NoError(t, err, "GetQueueAttributes RedrivePolicy")
		redrive, ok := out.Attributes[string(sqstypes.QueueAttributeNameRedrivePolicy)]
		require.True(t, ok, "RedrivePolicy attribute should be present on the primary queue")
		assert.Contains(t, redrive, dlqArn, "RedrivePolicy should reference the DLQ ARN")
	})

	t.Run("DDBTableExistsWithGSI", func(t *testing.T) {
		out, err := ddbClient.DescribeTable(t.Context(), &dynamodb.DescribeTableInput{
			TableName: aws.String(tableName),
		})
		require.NoError(t, err, "DescribeTable")
		require.NotNil(t, out.Table)
		assert.Equal(t, tableName, aws.ToString(out.Table.TableName))
		require.Len(t, out.Table.GlobalSecondaryIndexes, 1, "expected one GSI")
		assert.Equal(t, "gsi1", aws.ToString(out.Table.GlobalSecondaryIndexes[0].IndexName))
	})

	t.Run("EventBridgeBusExists", func(t *testing.T) {
		out, err := ebClient.DescribeEventBus(t.Context(), &eventbridge.DescribeEventBusInput{
			Name: aws.String(busName),
		})
		require.NoError(t, err, "DescribeEventBus")
		assert.Equal(t, busName, aws.ToString(out.Name))
		assert.Equal(t, busArn, aws.ToString(out.Arn))
	})
}

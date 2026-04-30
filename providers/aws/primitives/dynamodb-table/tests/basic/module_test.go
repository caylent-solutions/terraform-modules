package basic_test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestDynamodbTableBasicFeatures(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	tableArn := terraform.Output(t, ctx.Terraform, "table_arn")
	tableName := terraform.Output(t, ctx.Terraform, "table_name")
	streamArn := terraform.Output(t, ctx.Terraform, "stream_arn")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")
	ddb := dynamodb.NewFromConfig(cfg)

	t.Run("TableExists", func(t *testing.T) {
		assert.NotEmpty(t, tableArn, "table_arn should not be empty")
		assert.True(t, strings.HasPrefix(tableName, "test-ddb-table-"), "table name should be prefixed by var.table_name")
		assert.Contains(t, tableArn, ":dynamodb:", "table_arn should be a DynamoDB ARN")
	})

	t.Run("DescribeTableMatchesInputs", func(t *testing.T) {
		out, err := ddb.DescribeTable(t.Context(), &dynamodb.DescribeTableInput{
			TableName: aws.String(tableName),
		})
		require.NoError(t, err, "DescribeTable")

		desc := out.Table
		assert.Equal(t, "PAY_PER_REQUEST", string(desc.BillingModeSummary.BillingMode), "billing mode should match")

		// hash_key + range_key wired correctly
		var hash, sort string
		for _, k := range desc.KeySchema {
			switch k.KeyType {
			case "HASH":
				hash = aws.ToString(k.AttributeName)
			case "RANGE":
				sort = aws.ToString(k.AttributeName)
			}
		}
		assert.Equal(t, "pk", hash, "hash_key should be pk")
		assert.Equal(t, "sk", sort, "range_key should be sk")

		// GSI created
		require.Len(t, desc.GlobalSecondaryIndexes, 1, "exactly one GSI expected")
		assert.Equal(t, "gsi1", aws.ToString(desc.GlobalSecondaryIndexes[0].IndexName))
	})

	t.Run("StreamEnabled", func(t *testing.T) {
		assert.NotEmpty(t, streamArn, "stream_arn should not be empty when stream_enabled=true")

		out, err := ddb.DescribeTable(t.Context(), &dynamodb.DescribeTableInput{
			TableName: aws.String(tableName),
		})
		require.NoError(t, err, "DescribeTable")
		require.NotNil(t, out.Table.StreamSpecification, "stream_specification should be set")
		assert.True(t, aws.ToBool(out.Table.StreamSpecification.StreamEnabled), "stream should be enabled")
		assert.Equal(t, "NEW_AND_OLD_IMAGES", string(out.Table.StreamSpecification.StreamViewType))
	})

	t.Run("TtlEnabled", func(t *testing.T) {
		out, err := ddb.DescribeTimeToLive(t.Context(), &dynamodb.DescribeTimeToLiveInput{
			TableName: aws.String(tableName),
		})
		require.NoError(t, err, "DescribeTimeToLive")
		require.NotNil(t, out.TimeToLiveDescription)
		assert.Equal(t, "ENABLED", string(out.TimeToLiveDescription.TimeToLiveStatus))
		assert.Equal(t, "expires_at", aws.ToString(out.TimeToLiveDescription.AttributeName))
	})

	t.Run("PointInTimeRecoveryEnabled", func(t *testing.T) {
		out, err := ddb.DescribeContinuousBackups(t.Context(), &dynamodb.DescribeContinuousBackupsInput{
			TableName: aws.String(tableName),
		})
		require.NoError(t, err, "DescribeContinuousBackups")
		require.NotNil(t, out.ContinuousBackupsDescription)
		require.NotNil(t, out.ContinuousBackupsDescription.PointInTimeRecoveryDescription)
		assert.Equal(t, "ENABLED", string(out.ContinuousBackupsDescription.PointInTimeRecoveryDescription.PointInTimeRecoveryStatus))
	})

	t.Run("ServerSideEncryptionAlwaysOn", func(t *testing.T) {
		out, err := ddb.DescribeTable(t.Context(), &dynamodb.DescribeTableInput{
			TableName: aws.String(tableName),
		})
		require.NoError(t, err, "DescribeTable")
		require.NotNil(t, out.Table.SSEDescription, "SSEDescription should be present (encryption is always-on)")
		assert.Equal(t, "ENABLED", string(out.Table.SSEDescription.Status))
	})
}

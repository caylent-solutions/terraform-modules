package basic_test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/grafana"
	"github.com/aws/aws-sdk-go-v2/service/lambda"
	"github.com/aws/aws-sdk-go-v2/service/opensearch"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestTelemetryObservabilityBasic(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	osEndpoint := terraform.Output(t, ctx.Terraform, "opensearch_domain_endpoint")
	osName := terraform.Output(t, ctx.Terraform, "opensearch_domain_name")
	osArn := terraform.Output(t, ctx.Terraform, "opensearch_domain_arn")
	grafanaURL := terraform.Output(t, ctx.Terraform, "grafana_workspace_url")
	grafanaID := terraform.Output(t, ctx.Terraform, "grafana_workspace_id")
	grafanaArn := terraform.Output(t, ctx.Terraform, "grafana_workspace_arn")
	indexerName := terraform.Output(t, ctx.Terraform, "indexer_function_name")
	indexerArn := terraform.Output(t, ctx.Terraform, "indexer_function_arn")
	alarmsArn, err := terraform.OutputE(t, ctx.Terraform, "alarms_topic_arn")
	require.NoError(t, err, "alarms_topic_arn output should be readable (it is declared on the example)")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")

	osClient := opensearch.NewFromConfig(cfg)
	grafanaClient := grafana.NewFromConfig(cfg)
	lambdaClient := lambda.NewFromConfig(cfg)

	t.Run("OutputsPopulated", func(t *testing.T) {
		assert.NotEmpty(t, osEndpoint, "opensearch_domain_endpoint should be populated")
		assert.True(t, strings.HasPrefix(osName, "test-tobs-"), "opensearch domain name prefix")
		assert.True(t, strings.Contains(osArn, ":es:"), "opensearch ARN shape")
		assert.NotEmpty(t, grafanaURL)
		assert.NotEmpty(t, grafanaID)
		assert.True(t, strings.Contains(grafanaArn, ":grafana:"), "grafana ARN shape")
		assert.True(t, strings.HasPrefix(indexerName, "test-telemetry-indexer-"), "indexer name prefix")
		assert.True(t, strings.Contains(indexerArn, ":lambda:"), "lambda ARN shape")
		assert.Truef(t, alarmsArn == "" || alarmsArn == "<nil>", "basic example does not configure alarms_topic_arn (got %q)", alarmsArn)
	})

	t.Run("OpenSearchDomainExists", func(t *testing.T) {
		out, err := osClient.DescribeDomain(t.Context(), &opensearch.DescribeDomainInput{
			DomainName: aws.String(osName),
		})
		require.NoError(t, err, "DescribeDomain")
		require.NotNil(t, out.DomainStatus)
		assert.Equal(t, osName, aws.ToString(out.DomainStatus.DomainName))
	})

	t.Run("GrafanaWorkspaceExists", func(t *testing.T) {
		out, err := grafanaClient.DescribeWorkspace(t.Context(), &grafana.DescribeWorkspaceInput{
			WorkspaceId: aws.String(grafanaID),
		})
		require.NoError(t, err, "DescribeWorkspace")
		require.NotNil(t, out.Workspace)
		assert.Equal(t, grafanaID, aws.ToString(out.Workspace.Id))
	})

	t.Run("IndexerLambdaExists", func(t *testing.T) {
		out, err := lambdaClient.GetFunction(t.Context(), &lambda.GetFunctionInput{
			FunctionName: aws.String(indexerName),
		})
		require.NoError(t, err, "GetFunction")
		require.NotNil(t, out.Configuration)
		assert.Equal(t, indexerName, aws.ToString(out.Configuration.FunctionName))
		assert.Equal(t, indexerArn, aws.ToString(out.Configuration.FunctionArn))
	})
}

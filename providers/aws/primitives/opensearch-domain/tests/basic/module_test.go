package basic_test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/opensearch"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestOpensearchDomainBasicFeatures(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	domainArn := terraform.Output(t, ctx.Terraform, "domain_arn")
	domainName := terraform.Output(t, ctx.Terraform, "domain_name")
	endpoint := terraform.Output(t, ctx.Terraform, "endpoint")
	logGroupArn := terraform.Output(t, ctx.Terraform, "log_group_arn")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")
	os := opensearch.NewFromConfig(cfg)

	t.Run("DomainExists", func(t *testing.T) {
		assert.NotEmpty(t, domainArn)
		assert.True(t, strings.Contains(domainArn, ":es:"), "ARN should be an OpenSearch (ES) ARN")
		assert.True(t, strings.HasPrefix(domainName, "tt-os-"), "name should be prefixed by var.domain_name_prefix")
		assert.NotEmpty(t, endpoint, "endpoint should be populated")
		assert.NotEmpty(t, logGroupArn)
	})

	t.Run("DomainHasEncryptionAndHttps", func(t *testing.T) {
		out, err := os.DescribeDomain(t.Context(), &opensearch.DescribeDomainInput{
			DomainName: aws.String(domainName),
		})
		require.NoError(t, err, "DescribeDomain")
		s := out.DomainStatus
		require.NotNil(t, s)

		require.NotNil(t, s.EncryptionAtRestOptions)
		assert.True(t, aws.ToBool(s.EncryptionAtRestOptions.Enabled), "encrypt_at_rest must be enabled (always-on)")

		require.NotNil(t, s.NodeToNodeEncryptionOptions)
		assert.True(t, aws.ToBool(s.NodeToNodeEncryptionOptions.Enabled), "node_to_node_encryption must be enabled (always-on)")

		require.NotNil(t, s.DomainEndpointOptions)
		assert.True(t, aws.ToBool(s.DomainEndpointOptions.EnforceHTTPS), "enforce_https must be true (always-on)")
		assert.Equal(t, "Policy-Min-TLS-1-2-PFS-2023-10", string(s.DomainEndpointOptions.TLSSecurityPolicy))
	})

	t.Run("ApplicationLoggingEnabled", func(t *testing.T) {
		out, err := os.DescribeDomain(t.Context(), &opensearch.DescribeDomainInput{
			DomainName: aws.String(domainName),
		})
		require.NoError(t, err, "DescribeDomain")
		require.NotNil(t, out.DomainStatus)
		require.NotEmpty(t, out.DomainStatus.LogPublishingOptions, "log_publishing_options should be present")
		appLog, ok := out.DomainStatus.LogPublishingOptions["ES_APPLICATION_LOGS"]
		require.True(t, ok, "ES_APPLICATION_LOGS publishing should be configured")
		assert.True(t, aws.ToBool(appLog.Enabled))
		assert.Equal(t, logGroupArn, aws.ToString(appLog.CloudWatchLogsLogGroupArn))
	})
}

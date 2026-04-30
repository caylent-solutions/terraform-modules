package basic_test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/wafv2"
	wafv2types "github.com/aws/aws-sdk-go-v2/service/wafv2/types"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestWafWebaclBasicFeatures(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	webAclArn := terraform.Output(t, ctx.Terraform, "web_acl_arn")
	webAclName := terraform.Output(t, ctx.Terraform, "web_acl_name")
	logGroupArn := terraform.Output(t, ctx.Terraform, "log_group_arn")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")
	w := wafv2.NewFromConfig(cfg)

	t.Run("WebAclExists", func(t *testing.T) {
		assert.NotEmpty(t, webAclArn)
		assert.True(t, strings.Contains(webAclArn, ":wafv2:"), "ARN should be a WAFv2 ARN")
		assert.True(t, strings.HasPrefix(webAclName, "test-waf-webacl-"), "name should be prefixed by var.webacl_name")
		assert.NotEmpty(t, logGroupArn, "log_group_arn should be set when create_log_group=true")
	})

	// Extract the Web ACL id segment from the ARN (the GetWebACL API needs id+name+scope).
	parts := strings.Split(webAclArn, "/")
	require.GreaterOrEqual(t, len(parts), 3, "WAFv2 ARN should have id segment")
	webAclID := parts[len(parts)-1]

	t.Run("RuleSetMatchesInputs", func(t *testing.T) {
		out, err := w.GetWebACL(t.Context(), &wafv2.GetWebACLInput{
			Id:    aws.String(webAclID),
			Name:  aws.String(webAclName),
			Scope: wafv2types.ScopeRegional,
		})
		require.NoError(t, err, "GetWebACL")
		require.NotNil(t, out.WebACL)
		require.NotNil(t, out.WebACL.DefaultAction)
		assert.NotNil(t, out.WebACL.DefaultAction.Allow, "default_action=allow should produce DefaultAction.Allow")

		// Expected rules: 3 managed groups (defaults) + per-IP rate + per-header rate = 5
		ruleNames := make([]string, 0, len(out.WebACL.Rules))
		for _, r := range out.WebACL.Rules {
			ruleNames = append(ruleNames, aws.ToString(r.Name))
		}
		assert.Len(t, out.WebACL.Rules, 5, "expected 3 managed rule groups + 2 rate-based rules")
		assert.Contains(t, ruleNames, "AWSManagedRulesCommonRuleSet")
		assert.Contains(t, ruleNames, "AWSManagedRulesKnownBadInputsRuleSet")
		assert.Contains(t, ruleNames, "AWSManagedRulesAmazonIpReputationList")

		var perIP, perHeader *wafv2types.Rule
		for i := range out.WebACL.Rules {
			r := &out.WebACL.Rules[i]
			if strings.HasSuffix(aws.ToString(r.Name), "-rate-per-ip") {
				perIP = r
			}
			if strings.HasSuffix(aws.ToString(r.Name), "-rate-per-header") {
				perHeader = r
			}
		}
		require.NotNil(t, perIP, "per-IP rate rule should exist")
		require.NotNil(t, perHeader, "per-header rate rule should exist")

		require.NotNil(t, perIP.Statement.RateBasedStatement)
		assert.Equal(t, int64(2000), aws.ToInt64(perIP.Statement.RateBasedStatement.Limit))
		assert.Equal(t, wafv2types.RateBasedStatementAggregateKeyTypeIp, perIP.Statement.RateBasedStatement.AggregateKeyType)

		require.NotNil(t, perHeader.Statement.RateBasedStatement)
		assert.Equal(t, int64(1000), aws.ToInt64(perHeader.Statement.RateBasedStatement.Limit))
		assert.Equal(t, wafv2types.RateBasedStatementAggregateKeyTypeCustomKeys, perHeader.Statement.RateBasedStatement.AggregateKeyType)
		require.Len(t, perHeader.Statement.RateBasedStatement.CustomKeys, 1)
		require.NotNil(t, perHeader.Statement.RateBasedStatement.CustomKeys[0].Header)
		assert.Equal(t, "x-caylent-tool", aws.ToString(perHeader.Statement.RateBasedStatement.CustomKeys[0].Header.Name))
	})

	t.Run("LoggingConfigured", func(t *testing.T) {
		out, err := w.GetLoggingConfiguration(t.Context(), &wafv2.GetLoggingConfigurationInput{
			ResourceArn: aws.String(webAclArn),
		})
		require.NoError(t, err, "GetLoggingConfiguration")
		require.NotNil(t, out.LoggingConfiguration)
		require.GreaterOrEqual(t, len(out.LoggingConfiguration.LogDestinationConfigs), 1)
		assert.Equal(t, logGroupArn, out.LoggingConfiguration.LogDestinationConfigs[0])
	})
}

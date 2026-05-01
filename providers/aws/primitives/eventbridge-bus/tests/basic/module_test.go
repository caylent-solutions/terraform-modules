package basic_test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/eventbridge"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestEventbridgeBusBasicFeatures(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	busArn := terraform.Output(t, ctx.Terraform, "bus_arn")
	busName := terraform.Output(t, ctx.Terraform, "bus_name")
	ruleArns := terraform.OutputMap(t, ctx.Terraform, "rule_arns")
	targetQueueArn := terraform.Output(t, ctx.Terraform, "target_queue_arn")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")
	eb := eventbridge.NewFromConfig(cfg)

	t.Run("BusExists", func(t *testing.T) {
		assert.NotEmpty(t, busArn)
		assert.True(t, strings.Contains(busArn, ":events:"), "ARN should be an EventBridge ARN")
		assert.True(t, strings.HasPrefix(busName, "test-eb-bus-"))

		out, err := eb.DescribeEventBus(t.Context(), &eventbridge.DescribeEventBusInput{
			Name: aws.String(busName),
		})
		require.NoError(t, err, "DescribeEventBus")
		assert.Equal(t, busArn, aws.ToString(out.Arn))
	})

	t.Run("RuleAndTargetWired", func(t *testing.T) {
		require.Contains(t, ruleArns, "telemetry_events")
		assert.NotEmpty(t, ruleArns["telemetry_events"])

		rules, err := eb.ListRules(t.Context(), &eventbridge.ListRulesInput{
			EventBusName: aws.String(busName),
		})
		require.NoError(t, err, "ListRules")
		require.Len(t, rules.Rules, 1, "exactly one rule expected")
		ruleName := aws.ToString(rules.Rules[0].Name)
		assert.Equal(t, "ENABLED", string(rules.Rules[0].State))

		targets, err := eb.ListTargetsByRule(t.Context(), &eventbridge.ListTargetsByRuleInput{
			Rule:         aws.String(ruleName),
			EventBusName: aws.String(busName),
		})
		require.NoError(t, err, "ListTargetsByRule")
		require.Len(t, targets.Targets, 1, "exactly one target expected")
		assert.Equal(t, targetQueueArn, aws.ToString(targets.Targets[0].Arn))
		require.NotNil(t, targets.Targets[0].DeadLetterConfig)
		assert.NotEmpty(t, aws.ToString(targets.Targets[0].DeadLetterConfig.Arn))
		require.NotNil(t, targets.Targets[0].RetryPolicy)
		assert.Equal(t, int32(3600), aws.ToInt32(targets.Targets[0].RetryPolicy.MaximumEventAgeInSeconds))
		assert.Equal(t, int32(3), aws.ToInt32(targets.Targets[0].RetryPolicy.MaximumRetryAttempts))
	})
}

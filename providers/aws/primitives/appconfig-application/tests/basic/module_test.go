package basic_test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/appconfig"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestAppConfigApplicationBasicFeatures(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	appID := terraform.Output(t, ctx.Terraform, "application_id")
	appName := terraform.Output(t, ctx.Terraform, "application_name")
	envIDs := terraform.OutputMap(t, ctx.Terraform, "environment_ids")
	cpIDs := terraform.OutputMap(t, ctx.Terraform, "configuration_profile_ids")
	stratID := terraform.Output(t, ctx.Terraform, "deployment_strategy_id")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")
	ac := appconfig.NewFromConfig(cfg)

	t.Run("ApplicationExists", func(t *testing.T) {
		assert.NotEmpty(t, appID)
		assert.True(t, strings.HasPrefix(appName, "test-appconfig-app-"), "application name should be prefixed by var.application_name")

		out, err := ac.GetApplication(t.Context(), &appconfig.GetApplicationInput{
			ApplicationId: aws.String(appID),
		})
		require.NoError(t, err, "GetApplication")
		assert.Equal(t, appName, aws.ToString(out.Name))
	})

	t.Run("EnvironmentsCreated", func(t *testing.T) {
		require.Contains(t, envIDs, "dev")
		require.Contains(t, envIDs, "prod")

		dev, err := ac.GetEnvironment(t.Context(), &appconfig.GetEnvironmentInput{
			ApplicationId: aws.String(appID),
			EnvironmentId: aws.String(envIDs["dev"]),
		})
		require.NoError(t, err, "GetEnvironment dev")
		assert.Equal(t, "dev", aws.ToString(dev.Name))

		prod, err := ac.GetEnvironment(t.Context(), &appconfig.GetEnvironmentInput{
			ApplicationId: aws.String(appID),
			EnvironmentId: aws.String(envIDs["prod"]),
		})
		require.NoError(t, err, "GetEnvironment prod")
		assert.Equal(t, "prod", aws.ToString(prod.Name))
	})

	t.Run("FeatureFlagsConfigurationProfileExists", func(t *testing.T) {
		require.Contains(t, cpIDs, "feature_flags")
		out, err := ac.GetConfigurationProfile(t.Context(), &appconfig.GetConfigurationProfileInput{
			ApplicationId:          aws.String(appID),
			ConfigurationProfileId: aws.String(cpIDs["feature_flags"]),
		})
		require.NoError(t, err, "GetConfigurationProfile")
		assert.Equal(t, "feature-flags", aws.ToString(out.Name))
		assert.Equal(t, "AWS.AppConfig.FeatureFlags", aws.ToString(out.Type))
		assert.Equal(t, "hosted", aws.ToString(out.LocationUri))
	})

	t.Run("DeploymentStrategyMatchesInputs", func(t *testing.T) {
		require.NotEmpty(t, stratID)
		out, err := ac.GetDeploymentStrategy(t.Context(), &appconfig.GetDeploymentStrategyInput{
			DeploymentStrategyId: aws.String(stratID),
		})
		require.NoError(t, err, "GetDeploymentStrategy")
		assert.Equal(t, int32(5), out.DeploymentDurationInMinutes)
		assert.Equal(t, int32(5), out.FinalBakeTimeInMinutes)
		assert.InDelta(t, float32(20.0), aws.ToFloat32(out.GrowthFactor), 0.0001)
		assert.Equal(t, "LINEAR", string(out.GrowthType))
		assert.Equal(t, "NONE", string(out.ReplicateTo))
	})
}

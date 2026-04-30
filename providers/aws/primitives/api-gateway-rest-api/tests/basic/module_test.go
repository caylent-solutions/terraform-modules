package basic_test

import (
	"io"
	"net/http"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/apigateway"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestApiGatewayRestApiBasicFeatures(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	apiID := terraform.Output(t, ctx.Terraform, "rest_api_id")
	apiArn := terraform.Output(t, ctx.Terraform, "rest_api_arn")
	stageName := terraform.Output(t, ctx.Terraform, "stage_name")
	invokeURL := terraform.Output(t, ctx.Terraform, "stage_invoke_url")
	logGroupArn := terraform.Output(t, ctx.Terraform, "access_log_group_arn")
	usagePlanID := terraform.Output(t, ctx.Terraform, "usage_plan_id")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")
	apigw := apigateway.NewFromConfig(cfg)

	t.Run("RestApiExists", func(t *testing.T) {
		assert.NotEmpty(t, apiID)
		assert.Contains(t, apiArn, ":apigateway:", "rest_api_arn should be an API Gateway ARN")
		assert.Equal(t, "v1", stageName)
		assert.True(t, strings.HasPrefix(invokeURL, "https://"), "stage_invoke_url should be https")
	})

	t.Run("EndpointTypeIsRegional", func(t *testing.T) {
		out, err := apigw.GetRestApi(t.Context(), &apigateway.GetRestApiInput{
			RestApiId: aws.String(apiID),
		})
		require.NoError(t, err, "GetRestApi")
		require.NotNil(t, out.EndpointConfiguration)
		require.Len(t, out.EndpointConfiguration.Types, 1)
		assert.Equal(t, "REGIONAL", string(out.EndpointConfiguration.Types[0]))
	})

	t.Run("StageHasMethodSettingsAndAccessLog", func(t *testing.T) {
		out, err := apigw.GetStage(t.Context(), &apigateway.GetStageInput{
			RestApiId: aws.String(apiID),
			StageName: aws.String(stageName),
		})
		require.NoError(t, err, "GetStage")

		settings, ok := out.MethodSettings["*/*"]
		require.True(t, ok, "MethodSettings should contain `*/*`")
		assert.True(t, settings.MetricsEnabled, "method metrics should be enabled")
		assert.Equal(t, "ERROR", aws.ToString(settings.LoggingLevel))

		assert.NotEmpty(t, logGroupArn, "access_log_group_arn should be set when create_access_log_group=true")
		require.NotNil(t, out.AccessLogSettings)
		assert.NotEmpty(t, aws.ToString(out.AccessLogSettings.DestinationArn))
	})

	t.Run("UsagePlanCreated", func(t *testing.T) {
		require.NotEmpty(t, usagePlanID, "usage_plan_id should be set when create_usage_plan=true")
		out, err := apigw.GetUsagePlan(t.Context(), &apigateway.GetUsagePlanInput{
			UsagePlanId: aws.String(usagePlanID),
		})
		require.NoError(t, err, "GetUsagePlan")
		require.Len(t, out.ApiStages, 1)
		assert.Equal(t, apiID, aws.ToString(out.ApiStages[0].ApiId))
		assert.Equal(t, stageName, aws.ToString(out.ApiStages[0].Stage))
		require.NotNil(t, out.Throttle)
		assert.InDelta(t, 100.0, out.Throttle.RateLimit, 0.0001)
	})

	t.Run("MockGetRouteReturns200", func(t *testing.T) {
		// The stage's MOCK integration should return 200 with the expected body.
		req, err := http.NewRequestWithContext(t.Context(), http.MethodGet, invokeURL+"/", nil)
		require.NoError(t, err)
		resp, err := http.DefaultClient.Do(req)
		require.NoError(t, err, "GET %s", invokeURL)
		defer resp.Body.Close()
		body, err := io.ReadAll(resp.Body)
		require.NoError(t, err)
		assert.Equal(t, http.StatusOK, resp.StatusCode, "expected HTTP 200 from MOCK route")
		assert.Contains(t, string(body), "hello from api-gateway-rest-api basic example")
	})
}

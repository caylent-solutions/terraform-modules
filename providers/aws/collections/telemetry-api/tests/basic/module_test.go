package basic_test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/apigateway"
	"github.com/aws/aws-sdk-go-v2/service/lambda"
	"github.com/aws/aws-sdk-go-v2/service/wafv2"
	wafv2types "github.com/aws/aws-sdk-go-v2/service/wafv2/types"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestTelemetryApiBasic(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	apiInvokeURL := terraform.Output(t, ctx.Terraform, "api_invoke_url")
	customDomain, _ := terraform.OutputE(t, ctx.Terraform, "custom_domain_name")
	authorizerName := terraform.Output(t, ctx.Terraform, "authorizer_function_name")
	authorizerArn := terraform.Output(t, ctx.Terraform, "authorizer_function_arn")
	restAPIID := terraform.Output(t, ctx.Terraform, "rest_api_id")
	stageName := terraform.Output(t, ctx.Terraform, "stage_name")
	webACLArn := terraform.Output(t, ctx.Terraform, "web_acl_arn")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")

	apigwClient := apigateway.NewFromConfig(cfg)
	lambdaClient := lambda.NewFromConfig(cfg)
	wafClient := wafv2.NewFromConfig(cfg)

	t.Run("OutputsPopulated", func(t *testing.T) {
		assert.NotEmpty(t, apiInvokeURL, "api_invoke_url should be populated")
		assert.True(t, strings.HasPrefix(apiInvokeURL, "https://"), "invoke URL should be https")
		assert.True(t, strings.Contains(apiInvokeURL, ".execute-api."), "invoke URL should be an execute-api endpoint")
		assert.True(t, customDomain == "" || customDomain == "<nil>", "basic example does not configure a custom domain (got %q)", customDomain)
		assert.NotEmpty(t, authorizerName)
		assert.NotEmpty(t, authorizerArn)
		assert.NotEmpty(t, restAPIID)
		assert.Equal(t, "prod", stageName)
		assert.True(t, strings.Contains(webACLArn, ":wafv2:"), "ARN should be a WAFv2 ARN")
	})

	t.Run("RestAPIExists", func(t *testing.T) {
		out, err := apigwClient.GetRestApi(t.Context(), &apigateway.GetRestApiInput{
			RestApiId: aws.String(restAPIID),
		})
		require.NoError(t, err, "GetRestApi")
		assert.NotEmpty(t, aws.ToString(out.Id))
		assert.NotEmpty(t, aws.ToString(out.Name))
	})

	t.Run("StageExists", func(t *testing.T) {
		out, err := apigwClient.GetStage(t.Context(), &apigateway.GetStageInput{
			RestApiId: aws.String(restAPIID),
			StageName: aws.String(stageName),
		})
		require.NoError(t, err, "GetStage")
		assert.Equal(t, stageName, aws.ToString(out.StageName))
		assert.True(t, out.TracingEnabled, "X-Ray tracing should be enabled by default")
	})

	t.Run("AuthorizerLambdaExists", func(t *testing.T) {
		out, err := lambdaClient.GetFunction(t.Context(), &lambda.GetFunctionInput{
			FunctionName: aws.String(authorizerName),
		})
		require.NoError(t, err, "GetFunction")
		require.NotNil(t, out.Configuration)
		assert.Equal(t, authorizerName, aws.ToString(out.Configuration.FunctionName))
		assert.Equal(t, authorizerArn, aws.ToString(out.Configuration.FunctionArn))
	})

	t.Run("WebACLExists", func(t *testing.T) {
		parts := strings.Split(webACLArn, "/")
		require.GreaterOrEqual(t, len(parts), 3, "WAFv2 ARN should have id segment")
		webACLID := parts[len(parts)-1]
		webACLName := parts[len(parts)-2]

		out, err := wafClient.GetWebACL(t.Context(), &wafv2.GetWebACLInput{
			Id:    aws.String(webACLID),
			Name:  aws.String(webACLName),
			Scope: wafv2types.ScopeRegional,
		})
		require.NoError(t, err, "GetWebACL")
		require.NotNil(t, out.WebACL)
		assert.NotNil(t, out.WebACL.DefaultAction.Allow, "default_action=allow should produce DefaultAction.Allow")
	})
}

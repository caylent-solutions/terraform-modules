package basic_test

import (
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/grafana"
	grafanatypes "github.com/aws/aws-sdk-go-v2/service/grafana/types"
	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestManagedGrafanaWorkspaceBasic(t *testing.T) {
	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: "basic",
	})

	workspaceID := terraform.Output(t, ctx.Terraform, "workspace_id")
	workspaceArn := terraform.Output(t, ctx.Terraform, "workspace_arn")
	workspaceURL := terraform.Output(t, ctx.Terraform, "workspace_url")
	workspaceRoleArn := terraform.Output(t, ctx.Terraform, "workspace_role_arn")
	workspaceName := terraform.Output(t, ctx.Terraform, "workspace_name")

	cfg, err := config.LoadDefaultConfig(t.Context())
	require.NoError(t, err, "load default AWS config")
	g := grafana.NewFromConfig(cfg)

	t.Run("OutputsPopulated", func(t *testing.T) {
		assert.NotEmpty(t, workspaceID, "workspace_id should be populated")
		assert.NotEmpty(t, workspaceArn, "workspace_arn should be populated")
		assert.True(t, strings.Contains(workspaceArn, ":grafana:"), "ARN should be a Grafana ARN")
		assert.NotEmpty(t, workspaceURL, "workspace_url should be populated")
		assert.NotEmpty(t, workspaceRoleArn, "workspace_role_arn should be populated")
		assert.True(t, strings.HasPrefix(workspaceName, "test-grafana-"), "name should be prefixed by var.workspace_name")
	})

	t.Run("WorkspaceShapeMatchesInputs", func(t *testing.T) {
		out, err := g.DescribeWorkspace(t.Context(), &grafana.DescribeWorkspaceInput{
			WorkspaceId: aws.String(workspaceID),
		})
		require.NoError(t, err, "DescribeWorkspace")
		require.NotNil(t, out.Workspace)

		assert.Equal(t, workspaceName, aws.ToString(out.Workspace.Name))
		assert.Equal(t, grafanatypes.AccountAccessTypeCurrentAccount, out.Workspace.AccountAccessType)
		assert.Equal(t, grafanatypes.PermissionTypeServiceManaged, out.Workspace.PermissionType)

		require.NotNil(t, out.Workspace.Authentication, "Authentication summary should be populated")
		assert.Contains(t, out.Workspace.Authentication.Providers, grafanatypes.AuthenticationProviderTypesSaml,
			"basic example uses SAML auth provider")
		assert.Contains(t, out.Workspace.DataSources, grafanatypes.DataSourceTypeCloudwatch,
			"basic example enables the CLOUDWATCH data source")
		assert.Contains(t, out.Workspace.NotificationDestinations, grafanatypes.NotificationDestinationTypeSns,
			"basic example enables the SNS notification destination")
	})
}

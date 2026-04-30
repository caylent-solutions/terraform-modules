package basic

import (
	"fmt"
	"testing"
	"time"

	"github.com/caylent-solutions/terraform-terratest-framework/pkg/testctx"
	"github.com/stretchr/testify/assert"
)

// TestManagedGrafanaWorkspaceBasic provisions the basic example once and runs all assertions as subtests.
func TestManagedGrafanaWorkspaceBasic(t *testing.T) {
	t.Parallel()

	ctx := testctx.RunSingleExample(t, "../../examples", "basic", testctx.TestConfig{
		Name: fmt.Sprintf("grafana-basic-%d", time.Now().Unix()),
		ExtraVars: map[string]interface{}{
			"workspace_name": fmt.Sprintf("tst-grafana-%d", time.Now().Unix()),
		},
	})

	t.Run("WorkspaceID", func(t *testing.T) {
		t.Parallel()
		workspaceID := ctx.GetOutput(t, "workspace_id")
		assert.NotEmpty(t, workspaceID, "workspace_id should not be empty")
		assert.Regexp(t, `^g-[a-zA-Z0-9]+$`, workspaceID, "workspace_id should match Grafana workspace ID pattern")
	})

	t.Run("WorkspaceARN", func(t *testing.T) {
		t.Parallel()
		workspaceARN := ctx.GetOutput(t, "workspace_arn")
		assert.NotEmpty(t, workspaceARN, "workspace_arn should not be empty")
		assert.Contains(t, workspaceARN, "arn:aws:grafana:", "workspace_arn should be a valid Grafana ARN")
		assert.Contains(t, workspaceARN, ":workspace/", "workspace_arn should contain workspace path")
	})

	t.Run("WorkspaceURL", func(t *testing.T) {
		t.Parallel()
		workspaceURL := ctx.GetOutput(t, "workspace_url")
		assert.NotEmpty(t, workspaceURL, "workspace_url should not be empty")
		assert.Contains(t, workspaceURL, ".grafana.net", "workspace_url should be a Grafana endpoint")
	})
}

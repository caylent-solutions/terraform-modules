//go:build tools
// +build tools

// This file ensures that the tftest CLI and other required tools are tracked as dependencies for the monorepo.
// It is required for CI/CD and local development to ensure 'make install' works everywhere.

package tools

import (
	_ "github.com/caylent-solutions/terraform-terratest-framework/cmd/tftest"
)

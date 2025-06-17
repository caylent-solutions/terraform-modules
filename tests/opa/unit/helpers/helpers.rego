package tests.opa.unit.helpers

# Helper function to create a mock input with changed files
mock_pr_input(changed_files) := {"changed_files": changed_files}

# Helper function to create a mock input with files content
mock_files_input(files) := {"files": files}

# Helper function to create a mock input for terraform module tests
mock_terraform_module_input(module_path, files) := {
	"module_path": module_path,
	"files": files,
}

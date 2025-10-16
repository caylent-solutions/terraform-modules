package tests.opa.unit.helpers

import future.keywords.if

# Helper function to create a mock input with changed files
mock_pr_input(changed_files) := {"changed_files": changed_files}

# Helper function to create a mock input with files content
mock_files_input(files) := {"files": files}

# Helper function to create a mock input for terraform module tests
mock_terraform_module_input(module_path, files) := {
	"module_path": module_path,
	"repo_path": module_path,
	"files": files,
}

# Test to ensure helpers are covered
test_mock_pr_input if {
	result := mock_pr_input(["file1.tf", "file2.tf"])
	result.changed_files == ["file1.tf", "file2.tf"]
}

test_mock_files_input if {
	result := mock_files_input({"file.tf": "content"})
	result.files == {"file.tf": "content"}
}

test_mock_terraform_module_input if {
	result := mock_terraform_module_input("path/to/module", {"main.tf": "resource {}"})
	result.module_path == "path/to/module"
	result.files == {"main.tf": "resource {}"}
}

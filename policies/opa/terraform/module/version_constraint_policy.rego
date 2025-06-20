package terraform.module.version

import future.keywords.if
import future.keywords.in

# Check for minimum Terraform version
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Check if versions.tf exists
	versions_file := sprintf("%s/versions.tf", [module_path])

	# If file exists, check its content
	input.files[versions_file]
	content := input.files[versions_file]

	# Check if it contains the required version constraint
	not regex.match(`required_version\s*=\s*">=\s*1\.12\.1"`, content)

	result := {
		"policy": "terraform_version_constraint_policy",
		"severity": "error",
		"message": "Invalid Terraform version constraint",
		"details": "The module must specify required_version = \">= 1.12.1\" in versions.tf",
		"resolution": "Update versions.tf to include required_version = \">= 1.12.1\"",
	}
}

# Check if versions.tf exists
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Check if versions.tf exists
	versions_file := sprintf("%s/versions.tf", [module_path])
	not input.files[versions_file]

	result := {
		"policy": "terraform_version_constraint_policy",
		"severity": "error",
		"message": "Missing versions.tf file",
		"details": "Each module must have a versions.tf file with required_version constraint",
		"resolution": "Create a versions.tf file with required_version = \">= 1.12.1\"",
	}
}

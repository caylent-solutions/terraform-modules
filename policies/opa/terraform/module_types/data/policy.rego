package terraform.module.data

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Enforces that data modules:
# - Only contain data source blocks
# - Do not contain resource blocks
# - Do not contain module blocks
violation[result] if {
	# Check for resource blocks
	has_resource_blocks

	result := {
		"policy": "data_module_policy",
		"severity": "error",
		"message": "Data modules cannot contain resource blocks",
		"details": "Data modules should only contain data sources for querying existing resources",
		"resolution": "Replace resource blocks with data source blocks or move to appropriate module type",
	}
}

violation[result] if {
	# Check for module blocks
	has_module_blocks

	result := {
		"policy": "data_module_policy",
		"severity": "error",
		"message": "Data modules cannot contain module blocks",
		"details": "Data modules should only contain data sources for querying existing resources",
		"resolution": "Remove module blocks or move to collection module type",
	}
}

violation[result] if {
	# Check for at least one data source
	not has_data_sources

	result := {
		"policy": "data_module_policy",
		"severity": "error",
		"message": "Data modules must contain at least one data source",
		"details": "Data modules should contain data sources for querying existing resources",
		"resolution": "Add at least one data source to your data module",
	}
}

# Helper to check if any .tf files contain resource blocks
has_resource_blocks if {
	files := input.terraform_files
	count(files) > 0
	some _, content in files
	contains(content, "resource \"")
}

# Helper to check if any .tf files contain module blocks
has_module_blocks if {
	files := input.terraform_files
	count(files) > 0
	some _, content in files
	contains(content, "module \"")
}

# Helper to check if any .tf files contain data sources
has_data_sources if {
	files := input.terraform_files
	count(files) > 0
	some _, content in files
	contains(content, "data \"")
}
package terraform.libraries.data_sources_only

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
		"policy": "terraform_module_data_sources_only_policy",
		"severity": "error",
		"message": "Data modules cannot contain resource blocks",
		"details": "Data modules should only contain data sources for querying existing resources",
		"resolution": "Replace resource blocks with data source blocks or move to appropriate module type",
	}
}

violation[result] if {
	# Check for module blocks outside examples directory
	has_module_blocks_outside_examples

	result := {
		"policy": "terraform_module_data_sources_only_policy",
		"severity": "error",
		"message": "Data modules cannot contain module blocks outside examples directory",
		"details": "Data modules should contain locals blocks for constants. Module blocks are only allowed in examples directory for testing",
		"resolution": "Remove module blocks from module root or move to examples directory",
	}
}

violation[result] if {
	# Check for locals blocks in *-data.tf files
	not has_locals_in_data_files

	result := {
		"policy": "terraform_module_data_sources_only_policy",
		"severity": "error",
		"message": "Data modules must contain locals blocks in *-data.tf files",
		"details": "Data modules should contain locals blocks for constants in files matching pattern '*-data.tf'",
		"resolution": "Add locals blocks to your *-data.tf files",
	}
}

violation[result] if {
	# Check for at least one output in outputs.tf
	not has_outputs_in_outputs_file

	result := {
		"policy": "terraform_module_data_sources_only_policy",
		"severity": "error",
		"message": "Data modules must contain at least one output block in outputs.tf",
		"details": "Data modules should expose constants via output blocks in outputs.tf",
		"resolution": "Add at least one output block to outputs.tf",
	}
}

# Helper to check if any .tf files contain resource blocks
has_resource_blocks if {
	files := input.files
	count(files) > 0
	some file_path, content in files
	endswith(file_path, ".tf")
	contains(content, "resource \"")
}

# Helper to check if any .tf files contain module blocks outside examples directory
has_module_blocks_outside_examples if {
	files := input.files
	count(files) > 0
	some file_path, content in files
	endswith(file_path, ".tf")
	# Exclude files in examples directory
	not contains(file_path, "/examples/")
	contains(content, "module \"")
}

# Helper to check if *-data.tf files contain locals blocks
has_locals_in_data_files if {
	files := input.files
	count(files) > 0
	some file_path, content in files
	# Check if file path ends with pattern
	endswith(file_path, "-data.tf")
	contains(content, "locals {")
}

# Helper to check if outputs.tf contains output blocks
has_outputs_in_outputs_file if {
	files := input.files
	count(files) > 0
	some file_path, content in files
	# Check if file path ends with outputs.tf
	endswith(file_path, "outputs.tf")
	contains(content, "output \"")
}

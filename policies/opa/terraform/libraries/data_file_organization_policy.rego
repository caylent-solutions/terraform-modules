package terraform.libraries.data_file_organization

import future.keywords.contains
import future.keywords.if
import future.keywords.in

module_path := input.module_path

# Shared filter for all .tf files in the root of the module (excluding examples/tests)
tf_files := [file |
	some path in object.keys(input.files)
	startswith(path, sprintf("%s/", [module_path]))
	endswith(path, ".tf")
	rel := substring(path, count(module_path) + 1, -1)
	not startswith(rel, "examples/")
	not startswith(rel, "tests/")
	file := path
]

# If variable blocks exist, they must only be in variables.tf
violation[result] if {
	some file in tf_files
	not endswith(file, "/variables.tf")
	regex.match(`variable\s+"[^"]*"\s*{`, input.files[file])

	result := {
		"policy": "terraform_data_file_organization_policy",
		"severity": "error",
		"message": "Variable declarations must be in variables.tf",
		"details": sprintf("File '%s' contains variable declarations which should only be in variables.tf", [file]),
		"resolution": "Move all variable declarations to variables.tf",
	}
}

# If output blocks exist, they must only be in outputs.tf
violation[result] if {
	some file in tf_files
	not endswith(file, "/outputs.tf")
	regex.match(`output\s+"[^"]*"\s*{`, input.files[file])

	result := {
		"policy": "terraform_data_file_organization_policy",
		"severity": "error",
		"message": "Output declarations must be in outputs.tf",
		"details": sprintf("File '%s' contains output declarations which should only be in outputs.tf", [file]),
		"resolution": "Move all output declarations to outputs.tf",
	}
}

# If terraform blocks exist, they must only be in versions.tf
violation[result] if {
	some file in tf_files
	not endswith(file, "/versions.tf")
	regex.match(`terraform\s*{`, input.files[file])

	result := {
		"policy": "terraform_data_file_organization_policy",
		"severity": "error",
		"message": "Terraform blocks must be in versions.tf",
		"details": sprintf("File '%s' contains terraform blocks which should only be in versions.tf", [file]),
		"resolution": "Move all terraform blocks to versions.tf",
	}
}

# If required_providers blocks exist, they must only be in versions.tf
violation[result] if {
	some file in tf_files
	not endswith(file, "/versions.tf")
	regex.match(`required_providers\s*{`, input.files[file])

	result := {
		"policy": "terraform_data_file_organization_policy",
		"severity": "error",
		"message": "Required providers blocks must be in versions.tf",
		"details": sprintf("File '%s' contains required_providers blocks which should only be in versions.tf", [file]),
		"resolution": "Move all required_providers blocks to versions.tf",
	}
}

# If locals blocks exist, they must only be in locals.tf or *-data.tf files
violation[result] if {
	some file in tf_files
	not endswith(file, "/locals.tf")
	not is_data_tf_file(file)
	regex.match(`locals\s*{`, input.files[file])

	result := {
		"policy": "terraform_data_file_organization_policy",
		"severity": "error",
		"message": "Locals blocks must be in locals.tf or *-data.tf files",
		"details": sprintf("File '%s' contains locals blocks which should only be in locals.tf or files matching pattern '*-data.tf'", [file]),
		"resolution": "Move locals blocks to locals.tf or to a file matching pattern '<name>-data.tf'",
	}
}

# Helper function to check if a file is a *-data.tf file
is_data_tf_file(file_path) if {
	file_name := substring(file_path, count(module_path) + 1, -1)
	regex.match(`^[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*-data\.tf$`, file_name)
}

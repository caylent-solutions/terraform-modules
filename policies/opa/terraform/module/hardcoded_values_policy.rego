package terraform.module.hardcoded

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Check for hard-coded values in Terraform files
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Get all .tf files in the module root (excluding examples, tests, outputs.tf, and versions.tf)
	tf_files := {file |
		some path in object.keys(input.files)
		startswith(path, sprintf("%s/", [module_path]))
		endswith(path, ".tf")
		not contains(path, "/examples/")
		not contains(path, "/tests/")
		not endswith(path, "/variables.tf")
		not endswith(path, "/outputs.tf")
		not endswith(path, "/versions.tf")
		file := path
	}

	# Check each file for hard-coded values
	some file in tf_files
	content := input.files[file]
	contains_hardcoded_value(content)

	result := {
		"policy": "terraform_module_hardcoded_values_policy",
		"severity": "error",
		"message": "Terraform file contains hard-coded values",
		"details": sprintf("File '%s' contains hard-coded values which should be variables", [file]),
		"resolution": "Replace hard-coded values with variables or use variable interpolation ${var.name}",
	}
}

# Helper functions to detect hard-coded values in Terraform code

# Match attribute assignments in resource blocks with hard-coded string values
contains_hardcoded_value(content) if {
	regex.match(`resource\s+"[^"]+"\s+"[^"]+"\s+{[^}]*\w+\s*=\s*"[^${}][^"]*"[^}]*}`, content)
}

# Match hardcoded string assignments not using interpolation
contains_hardcoded_value(content) if {
	regex.match(`\w+\s*=\s*"[^${}][^"]*"`, content)
}

# Match hardcoded numeric values
contains_hardcoded_value(content) if {
	regex.match(`\w+\s*=\s*\d+`, content)
}

# Match hardcoded booleans
contains_hardcoded_value(content) if {
	regex.match(`\w+\s*=\s*(true|false)`, content)
}

# Match hardcoded JSON-style maps
contains_hardcoded_value(content) if {
	regex.match(`\w+\s*=\s*\{[^${}]*"[^${}][^"]*"[^}]*\}`, content)
}

# Match hardcoded YAML heredocs
contains_hardcoded_value(content) if {
	regex.match(`\w+\s*=\s*<<(YAML|YML)[^${}]*`, content)
}

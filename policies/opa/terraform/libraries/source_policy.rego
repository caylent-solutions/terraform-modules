package terraform.libraries.source

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Check for local module sources
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Get all .tf files in the module (excluding examples and tests)
	tf_files := {file |
		some path in object.keys(input.files)
		startswith(path, sprintf("%s/", [module_path]))
		endswith(path, ".tf")
		not contains(path, "/examples/")
		not contains(path, "/tests/")
		file := path
	}

	# Check each file for local module sources
	some file in tf_files
	content := input.files[file]
	contains_local_module_source(content)

	result := {
		"policy": "terraform_module_source_policy",
		"severity": "error",
		"message": "Local module source detected",
		"details": sprintf("File '%s' contains a reference to a local module source", [file]),
		"resolution": "Use remote module sources instead of local paths",
	}
}

# Check for non-monorepo module sources
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Get all .tf files in the module (excluding examples and tests)
	tf_files := {file |
		some path in object.keys(input.files)
		startswith(path, sprintf("%s/", [module_path]))
		endswith(path, ".tf")
		not contains(path, "/examples/")
		not contains(path, "/tests/")
		file := path
	}

	# Check each file for module sources not from this monorepo
	some file in tf_files
	content := input.files[file]

	# Find module blocks
	regex.match(`module\s+"[^"]+"\s+{`, content)
	contains(content, "source")
	not is_monorepo_source(content)

	result := {
		"policy": "terraform_module_source_policy",
		"severity": "error",
		"message": "Module source must be from this monorepo",
		"details": sprintf("File '%s' contains a module source that is not from the Caylent terraform-modules monorepo", [file]),
		"resolution": "Use module sources from git::https://github.com/caylent-solutions/terraform-modules.git only",
	}
}

# Check for monorepo sources without ref parameter
violation[result] if {
	# Get module path from input
	module_path := input.module_path

	# Get all .tf files in the module (excluding examples and tests)
	tf_files := {file |
		some path in object.keys(input.files)
		startswith(path, sprintf("%s/", [module_path]))
		endswith(path, ".tf")
		not contains(path, "/examples/")
		not contains(path, "/tests/")
		file := path
	}

	# Check each file for monorepo sources without ref
	some file in tf_files
	content := input.files[file]

	# Find module blocks with monorepo source
	regex.match(`module\s+"[^"]+"\s+{`, content)
	is_monorepo_source(content)
	not has_ref_parameter(content)

	result := {
		"policy": "terraform_module_source_policy",
		"severity": "error",
		"message": "Monorepo module source missing ref parameter",
		"details": sprintf("File '%s' contains a monorepo module source without a ?ref= parameter", [file]),
		"resolution": "Add ?ref=<version> to the module source URL",
	}
}

# Helper functions
contains_local_module_source(content) if {
	# Check for relative paths in module sources (./ or ../)
	regex.match(`source\s*=\s*"\.\.?/`, content)
}

contains_local_module_source(content) if {
	# Check for absolute paths in module sources
	regex.match(`source\s*=\s*"/`, content)
}

is_monorepo_source(content) if {
	# Check if source is from this monorepo via git
	regex.match(`source\s*=\s*"git::https://github\.com/caylent-solutions/terraform-modules\.git//`, content)
}

has_ref_parameter(content) if {
	# Check if source has ?ref= parameter with valid tag format
	# Valid format: <module-path>/v<semver>
	# Example: providers/aws/primitives/s3/v1.0.0
	regex.match(`source\s*=\s*"git::https://github\.com/caylent-solutions/terraform-modules\.git//[^?]+\?ref=.+/v[0-9]+\.[0-9]+\.[0-9]+"`, content)
}

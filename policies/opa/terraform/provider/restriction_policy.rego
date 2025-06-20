package terraform.module.providers

import future.keywords.if
import future.keywords.in

# Disallowed cloud providers
disallowed_providers := [
	"azurerm",
	"google",
	"google-beta",
	"azuread",
]

# Check for disallowed cloud providers
violation[result] if {
	module_path := input.module_path

	# Get all .tf files in the module
	tf_files := {file |
		some path in object.keys(input.files)
		startswith(path, sprintf("%s/", [module_path]))
		endswith(path, ".tf")
		file := path
	}

	# Scan content for disallowed provider names
	some file in tf_files
	content := input.files[file]
	some provider in disallowed_providers

	# Match `provider` blocks with or without quotes
	pattern := sprintf(`(?m)provider\s*["']?%s["']?\s*\{`, [provider])
	regex.match(pattern, content)

	result := {
		"policy": "provider_restriction_policy",
		"severity": "error",
		"message": sprintf("Disallowed cloud provider detected: %s", [provider]),
		"details": sprintf("File %s contains reference to %s provider. Only AWS is allowed among major cloud providers.", [file, provider]),
		"resolution": "Remove the disallowed provider and use AWS resources instead",
	}
}

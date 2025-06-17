package terraform.module.license

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# Check for additional license files or statements
violation[result] if {
	# Get all files in the repository
	all_files := object.keys(input.files)

	# Check for LICENSE files other than the root LICENSE
	some file in all_files
	file_is_license(file)
	file != "LICENSE" # Exclude the root LICENSE file

	result := {
		"policy": "license_policy",
		"severity": "error",
		"message": "Additional LICENSE files are not allowed",
		"details": sprintf("Found additional LICENSE file: %s", [file]),
		"resolution": "Remove the additional LICENSE file. Only the Apache 2.0 license at the repository root is allowed.",
	}
}

# Check for license statements in files
violation[result] if {
	# Get all files in the repository
	all_files := object.keys(input.files)

	# Check for license statements in files
	some file in all_files
	content := input.files[file]

	# Look for common license statement patterns
	has_license_keyword(content)
	has_license_type(content)

	# Exclude the root LICENSE file
	file != "LICENSE"

	result := {
		"policy": "license_policy",
		"severity": "error",
		"message": "Additional license statements are not allowed",
		"details": sprintf("Found license statement in file: %s", [file]),
		"resolution": "Remove the license statement. Only the Apache 2.0 license at the repository root is allowed.",
	}
}

# Helper function to check if a file is a license file
file_is_license(file) if {
	endswith(file, "LICENSE")
}

file_is_license(file) if {
	endswith(file, "License")
}

file_is_license(file) if {
	endswith(file, "license")
}

# Helper function to check if content has license keywords
has_license_keyword(content) if {
	contains(lower(content), "license")
}

has_license_keyword(content) if {
	contains(lower(content), "copyright")
}

has_license_keyword(content) if {
	contains(lower(content), "all rights reserved")
}

has_license_keyword(content) if {
	contains(lower(content), "permission is hereby granted")
}

# Helper function to check if content has license types
has_license_type(content) if {
	contains(lower(content), "mit license")
}

has_license_type(content) if {
	contains(lower(content), "apache license")
}

has_license_type(content) if {
	contains(lower(content), "gnu")
}

has_license_type(content) if {
	contains(lower(content), "gpl")
}

has_license_type(content) if {
	contains(lower(content), "lgpl")
}

has_license_type(content) if {
	contains(lower(content), "bsd")
}

has_license_type(content) if {
	contains(lower(content), "mozilla")
}

has_license_type(content) if {
	contains(lower(content), "mpl")
}

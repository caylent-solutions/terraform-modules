package terraform.module.license.test

import data.terraform.module.license as policy
import data.tests.opa.unit.helpers as helpers

# Test that additional LICENSE files violate the policy
test_additional_license_file_violation if {
	# Mock input with additional LICENSE files
	files := {
		"LICENSE": "Apache 2.0 License content",
		"src/LICENSE": "MIT License content",
	}
	test_input := helpers.mock_files_input(files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect one violation
	count(violations) >= 1

	# Check that the violation is what we expect
	violations[{"policy": "license_policy", "severity": "error", "message": "Additional LICENSE files are not allowed", "details": "Found additional LICENSE file: src/LICENSE", "resolution": "Remove the additional LICENSE file. Only the Apache 2.0 license at the repository root is allowed."}]
}

# Test that license statements in files violate the policy
test_license_statement_violation if {
	# Mock input with files containing license statements
	files := {
		"LICENSE": "Apache 2.0 License content",
		"src/file.js": "// Copyright 2023. MIT License. All rights reserved.",
	}
	test_input := helpers.mock_files_input(files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect one violation
	count(violations) >= 1

	# Check that the violation is what we expect
	violations[{"policy": "license_policy", "severity": "error", "message": "Additional license statements are not allowed", "details": "Found license statement in file: src/file.js", "resolution": "Remove the license statement. Only the Apache 2.0 license at the repository root is allowed."}]
}

# Test that compliant files pass the policy
test_compliant_files_no_violation if {
	# Mock input with compliant files
	files := {
		"LICENSE": "Apache 2.0 License content",
		"src/file.js": "// This is a regular comment with no license statement",
	}
	test_input := helpers.mock_files_input(files)

	# Check for violations
	violations := policy.violation with input as test_input

	# Expect no violations
	count(violations) == 0
}

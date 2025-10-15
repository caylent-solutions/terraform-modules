package terraform.module_types.primitive.tests_helpers

import data.terraform.libraries.tests_helpers

# Import tests helpers policy from library
violation[result] if {
	result := tests_helpers.violation[_]
}

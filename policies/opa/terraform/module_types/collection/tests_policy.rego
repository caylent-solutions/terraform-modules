package terraform.module_types.collection.tests

import data.terraform.libraries.tests

# Import tests policy from library
violation[result] if {
	result := tests.violation[_]
}

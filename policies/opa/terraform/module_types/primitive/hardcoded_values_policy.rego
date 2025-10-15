package terraform.module_types.primitive.hardcoded

import data.terraform.libraries.hardcoded

# Import hardcoded values policy from library
violation[result] if {
	result := hardcoded.violation[_]
}
package terraform.module_types.reference.naming

import data.terraform.libraries.naming

# Import naming policy from library
violation[result] if {
	result := naming.violation[_]
}

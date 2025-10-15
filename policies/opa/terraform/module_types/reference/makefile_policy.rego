package terraform.module_types.reference.makefile

import data.terraform.libraries.makefile

# Import makefile policy from library
violation[result] if {
	result := makefile.violation[_]
}

package terraform.module_types.primitive.makefile

import data.terraform.libraries.makefile

# Import makefile policy from library
violation[result] if {
	result := makefile.violation[_]
}

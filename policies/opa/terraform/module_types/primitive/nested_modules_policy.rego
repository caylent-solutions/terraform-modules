package terraform.module_types.primitive.nested_modules

import data.terraform.libraries.nested_modules

# Import nested modules policy from library
violation[result] if {
	result := nested_modules.violation[_]
}

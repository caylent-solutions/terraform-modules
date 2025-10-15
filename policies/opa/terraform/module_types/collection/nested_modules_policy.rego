package terraform.module_types.collection.nested_modules

import data.terraform.libraries.nested_modules

# Import nested modules policy from library
violation[result] if {
	result := nested_modules.violation[_]
}

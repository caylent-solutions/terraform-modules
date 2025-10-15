package terraform.module_types.primitive.source

import data.terraform.libraries.source

# Import source policy from library
violation[result] if {
	result := source.violation[_]
}

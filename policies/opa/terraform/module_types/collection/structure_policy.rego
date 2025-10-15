package terraform.module_types.collection.structure

import data.terraform.libraries.structure

# Import structure policy from library
violation[result] if {
	result := structure.violation[_]
}

package terraform.module_types.collection.structure_examples

import data.terraform.libraries.structure_examples

# Import structure examples policy from library
violation[result] if {
	result := structure_examples.violation[_]
}

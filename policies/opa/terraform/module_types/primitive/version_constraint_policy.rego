package terraform.module_types.primitive.version_constraint

import data.terraform.libraries.version_constraint

# Import version constraint policy from library
violation[result] if {
	result := version_constraint.violation[_]
}

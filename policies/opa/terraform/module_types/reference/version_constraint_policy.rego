package terraform.module_types.reference.version_constraint

import data.terraform.libraries.version_constraint

# Import version constraint policy from library
violation[result] if {
	result := version_constraint.violation[_]
}

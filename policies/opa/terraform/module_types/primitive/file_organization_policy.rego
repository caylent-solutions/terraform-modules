package terraform.module_types.primitive.file_organization

import data.terraform.libraries.file_organization

# Import file organization policy from library
violation[result] if {
	result := file_organization.violation[_]
}

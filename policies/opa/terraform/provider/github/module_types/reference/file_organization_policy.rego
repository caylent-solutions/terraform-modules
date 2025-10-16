package terraform.provider.github.module_types.reference.file_organization

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.file_organization

# Re-export library violations
violation := file_organization.violation

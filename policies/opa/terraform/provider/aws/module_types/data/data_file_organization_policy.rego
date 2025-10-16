package terraform.provider.aws.module_types.data.file_organization

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.data_file_organization

# Re-export library violations
violation := data_file_organization.violation

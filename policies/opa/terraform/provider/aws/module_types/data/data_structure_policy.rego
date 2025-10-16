package terraform.provider.aws.module_types.data

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.data_structure

# Re-export library violations
violation := data_structure.violation

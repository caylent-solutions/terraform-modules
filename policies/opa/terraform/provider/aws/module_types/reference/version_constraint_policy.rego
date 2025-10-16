package terraform.provider.aws.module_types.reference.version_constraint

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.version_constraint

# Re-export library violations
violation := version_constraint.violation

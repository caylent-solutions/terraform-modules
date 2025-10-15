package terraform.provider.none.module_types.skeleton.structure

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.structure

# Re-export library violations
violation := structure.violation

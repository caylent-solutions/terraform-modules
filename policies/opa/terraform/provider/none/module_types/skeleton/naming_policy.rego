package terraform.provider.none.module_types.skeleton.naming

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.naming

# Re-export library violations
violation := naming.violation

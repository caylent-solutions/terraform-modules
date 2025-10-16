package terraform.provider.none.module_types.skeleton.source

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.source

# Re-export library violations
violation := source.violation

package terraform.provider.none.module_types.skeleton.hardcoded

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.hardcoded

# Re-export library violations
violation := hardcoded.violation

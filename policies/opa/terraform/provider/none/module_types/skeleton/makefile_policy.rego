package terraform.provider.none.module_types.skeleton.makefile

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.makefile

# Re-export library violations
violation := makefile.violation

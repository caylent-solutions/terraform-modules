package terraform.provider.github.module_types.reference.makefile

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.makefile

# Re-export library violations
violation := makefile.violation

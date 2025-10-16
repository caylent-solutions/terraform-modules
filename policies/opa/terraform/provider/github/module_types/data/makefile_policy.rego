package terraform.module.data

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.makefile

# Re-export library violations
violation := makefile.violation

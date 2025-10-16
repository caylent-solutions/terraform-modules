package terraform.module.data

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.data_sources_only

# Re-export library violations
violation := data_sources_only.violation

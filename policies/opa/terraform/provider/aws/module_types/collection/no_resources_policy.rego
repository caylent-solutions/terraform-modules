package terraform.provider.aws.module_types.collection

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.no_resources

# Re-export library violations
violation := no_resources.violation

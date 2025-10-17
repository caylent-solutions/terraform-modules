package terraform.provider.aws.module_types.primitive.source

# This policy imports and re-exports the library policy
# The module validator loads libraries via --bundle flag
import data.terraform.libraries.source

# Re-export library violations
violation := source.violation

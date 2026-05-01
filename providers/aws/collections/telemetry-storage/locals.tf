# Locals are intentionally empty for the telemetry-storage collection:
# the collection is a pure pass-through to the sqs-queue, dynamodb-table,
# and eventbridge-bus primitives. OPA's hardcoded_values_policy requires
# any literal-bearing locals to use opaque expressions, but no literals
# are needed here.

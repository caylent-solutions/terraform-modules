variable "queue_name" {
  description = "Base name for the SQS ingest queue; the example appends a random suffix."
  type        = string
  default     = "test-telemetry-ingest"
}

variable "table_name" {
  description = "Base name for the DynamoDB table; the example appends a random suffix."
  type        = string
  default     = "test-telemetry-events"
}

variable "bus_name" {
  description = "Base name for the EventBridge bus; the example appends a random suffix."
  type        = string
  default     = "test-telemetry-bus"
}

variable "tags" {
  description = "Tags applied to module-managed resources."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Module    = "telemetry-storage"
    Example   = "basic"
  }
}

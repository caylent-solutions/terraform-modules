name                            = "test-telemetry-queue"
visibility_timeout_seconds      = 30
message_retention_seconds       = 345600
kms_key_description             = "CMK for telemetry SQS queue encryption"
kms_key_deletion_window_in_days = 7
kms_key_enable_rotation         = true
enable_dlq                      = true
dlq_name                        = "test-telemetry-queue-dlq"
max_receive_count               = 5
enable_dlq_alarm                = true
dlq_alarm_name                  = "test-telemetry-queue-dlq-depth"
dlq_alarm_threshold             = 0
tags = {
  Environment = "test"
  Purpose     = "sqs-queue-module-testing"
  Owner       = "terraform"
}

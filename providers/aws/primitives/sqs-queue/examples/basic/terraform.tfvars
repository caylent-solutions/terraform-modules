queue_name = "test-sqs-queue"

fifo_queue                 = false
visibility_timeout_seconds = 30
message_retention_seconds  = 345600
receive_wait_time_seconds  = 10

create_dlq        = true
max_receive_count = 3

create_dlq_depth_alarm    = true
dlq_depth_alarm_threshold = 1

tags = {
  Environment = "test"
  ManagedBy   = "terraform"
}

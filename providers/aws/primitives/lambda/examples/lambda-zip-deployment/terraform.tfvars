function_name = "test-lambda-zip"

runtime     = "python3.12"
timeout     = 30
memory_size = 256

environment_variables = {
  LOG_LEVEL = "INFO"
  ENV       = "test"
}

enable_vpc          = false
enable_event_source = true
batch_size          = 10

tags = {
  Environment = "test"
  ManagedBy   = "terraform"
}

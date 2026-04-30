function_name = "test-lambda-docker"

# Image URI is built and pushed automatically by terraform
# image_uri is not needed - it's constructed from ECR repo

image_command = ["app.handler"]

architectures = ["arm64"]
timeout       = 60
memory_size   = 2048

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

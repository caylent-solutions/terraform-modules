resource "local_file" "output" {
  content         = var.output_content
  filename        = var.output_filename
  file_permission = var.file_permission
}

# Generate a timestamp for testing purposes
resource "time_static" "creation_time" {
  triggers = {
    file_content = local_file.output.content
  }
}
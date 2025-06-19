# This file violates the nested modules policy by being in a subdirectory

resource "local_file" "nested_file" {
  content  = "nested hardcoded content"  # Hardcoded content
  filename = "/tmp/nested-hardcoded.txt"  # Hardcoded filename
  
  file_permission = "0600"  # Hardcoded permission
}
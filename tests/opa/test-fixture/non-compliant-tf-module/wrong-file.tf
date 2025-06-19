# This file contains azurerm provider block to fail restriction policy

provider "azurerm" {
  features {}
}

resource "local_file" "hardcoded_config" {
  content  = "hardcoded configuration data"
  filename = "/tmp/hardcoded-config.json"
  file_permission = "0755"
}
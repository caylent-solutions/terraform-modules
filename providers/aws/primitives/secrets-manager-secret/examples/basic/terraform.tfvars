name                    = "telemetry-basic-secret"
description             = "Basic example secret for secrets-manager-secret module"
recovery_window_in_days = 7
enable_rotation         = false
rotation_days           = 90
tags = {
  Environment = "test"
  Purpose     = "secrets-manager-secret-module-testing"
  Owner       = "terraform"
}

output "control_reference" {
  value       = local.available_controls
  description = "List of all available AWS Control Tower controls with descriptions."
}

output "controltower_controls" {
  value       = aws_controltower_control.this
  description = "Map of AWS Control Tower controls applied to the organization."
}


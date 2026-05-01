variable "zone_name_prefix" {
  description = "Base zone name prefix (a random suffix is appended); the zone is created as `<prefix>-<suffix>.internal` in a fresh test VPC."
  type        = string
}

variable "tags" {
  description = "Tags applied to the test VPC and hosted zone."
  type        = map(string)
  default     = {}
}

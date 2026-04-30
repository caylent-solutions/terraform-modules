variable "zone_name" {
  type        = string
  description = "The DNS name of the hosted zone to create for testing"
  default     = "caylent-terratest-r53-record.net"
}

variable "record_name" {
  type        = string
  description = "The name of the DNS record to create"
  default     = "api.caylent-terratest-r53-record.net"
}

variable "record_type" {
  type        = string
  description = "The type of the DNS record"
  default     = "A"
}

variable "ttl" {
  type        = number
  description = "The TTL of the record in seconds"
  default     = 300
}

variable "records" {
  type        = list(string)
  description = "A list of record values"
  default     = ["1.2.3.4"]
}


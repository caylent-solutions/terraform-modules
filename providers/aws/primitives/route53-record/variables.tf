variable "zone_id" {
  type        = string
  description = "(Required) The ID of the hosted zone in which to create the record."
}

variable "name" {
  type        = string
  description = "(Required) The name of the record. Do not include a trailing dot."
}

variable "type" {
  type        = string
  description = "(Required) The record type. Valid values: A, AAAA, CAA, CNAME, DS, MX, NAPTR, NS, PTR, SOA, SPF, SRV, TXT."
  validation {
    condition     = contains(["A", "AAAA", "CAA", "CNAME", "DS", "MX", "NAPTR", "NS", "PTR", "SOA", "SPF", "SRV", "TXT"], var.type)
    error_message = "type must be one of: A, AAAA, CAA, CNAME, DS, MX, NAPTR, NS, PTR, SOA, SPF, SRV, TXT."
  }
}

variable "ttl" {
  type        = number
  description = "(Optional) The TTL of the record in seconds. Required when not using an alias block. Mutually exclusive with alias."
  default     = null
  validation {
    condition     = var.ttl == null || var.ttl > 0
    error_message = "ttl must be greater than 0 when specified."
  }
}

variable "records" {
  type        = list(string)
  description = "(Optional) A string list of records. Required when not using an alias block. Mutually exclusive with alias."
  default     = null
}

variable "alias" {
  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = bool
  })
  description = "(Optional) An alias block for routing to AWS resources. Mutually exclusive with ttl and records."
  default     = null
}

variable "allow_overwrite" {
  type        = bool
  description = "(Optional) Allow creation of this record in Terraform to overwrite an existing record, if any. Defaults to false."
  default     = false
}

variable "health_check_id" {
  type        = string
  description = "(Optional) The health check the record should be associated with."
  default     = null
}

variable "set_identifier" {
  type        = string
  description = "(Optional) Unique identifier to differentiate records with routing policies. Required for failover, geolocation, latency, and weighted routing policies."
  default     = null
}

variable "weighted_routing_policy" {
  type = object({
    weight = number
  })
  description = "(Optional) A block indicating a weighted routing policy. Requires set_identifier."
  default     = null
}

variable "failover_routing_policy" {
  type = object({
    type = string
  })
  description = "(Optional) A block indicating the routing behavior when associated health check fails. Valid values: PRIMARY, SECONDARY. Requires set_identifier."
  default     = null
  validation {
    condition     = var.failover_routing_policy == null || contains(["PRIMARY", "SECONDARY"], coalesce(try(var.failover_routing_policy.type, null), "PRIMARY"))
    error_message = "failover_routing_policy.type must be PRIMARY or SECONDARY when specified."
  }
}

variable "geolocation_routing_policy" {
  type = object({
    continent   = optional(string)
    country     = optional(string)
    subdivision = optional(string)
  })
  description = "(Optional) A block indicating a routing policy based on the geolocation of the requestor. Requires set_identifier."
  default     = null
}

variable "latency_routing_policy" {
  type = object({
    region = string
  })
  description = "(Optional) A block indicating a routing policy based on the latency between the requestor and an AWS region. Requires set_identifier."
  default     = null
}

variable "multivalue_answer_routing_policy" {
  type        = bool
  description = "(Optional) Set to true to indicate a multivalue answer routing policy. Requires set_identifier."
  default     = null
}


variable "zone_id" {
  description = "Hosted zone id where the record is created. The zone must already exist; this primitive does not provision the zone."
  type        = string
}

variable "name" {
  description = "Record name (DNS name). May be relative (`api`) or fully-qualified (`api.example.com.`)."
  type        = string
}

variable "type" {
  description = "Record type. One of A, AAAA, CNAME, CAA, MX, NAPTR, NS, PTR, SOA, SPF, SRV, TXT."
  type        = string

  validation {
    condition     = contains(["A", "AAAA", "CNAME", "CAA", "MX", "NAPTR", "NS", "PTR", "SOA", "SPF", "SRV", "TXT"], var.type)
    error_message = "type must be one of A, AAAA, CNAME, CAA, MX, NAPTR, NS, PTR, SOA, SPF, SRV, TXT."
  }
}

variable "ttl" {
  description = "Record TTL in seconds. Required when alias is null. Ignored when alias is set."
  type        = number
  default     = 300

  validation {
    condition     = var.ttl >= 0
    error_message = "ttl must be >= 0."
  }
}

variable "records" {
  description = "List of record values (rdata). Required when alias is null; null/empty when alias is set."
  type        = list(string)
  default     = []
}

variable "alias" {
  description = "Alias target. When set, `ttl` and `records` are ignored. `{ name, zone_id, evaluate_target_health }`."
  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = bool
  })
  default = null
}

variable "set_identifier" {
  description = "Optional identifier for routing-policy records (weighted/failover/latency/geolocation)."
  type        = string
  default     = null
}

variable "health_check_id" {
  description = "Optional Route53 health check ID."
  type        = string
  default     = null
}

variable "weighted_routing_policy" {
  description = "Weighted routing policy: `{ weight = number }`. Mutually exclusive with the other routing policies."
  type = object({
    weight = number
  })
  default = null
}

variable "failover_routing_policy" {
  description = "Failover routing policy: `{ type = \"PRIMARY\"|\"SECONDARY\" }`. Mutually exclusive with other routing policies."
  type = object({
    type = string
  })
  default = null

  validation {
    condition     = var.failover_routing_policy == null || contains(["PRIMARY", "SECONDARY"], try(var.failover_routing_policy.type, ""))
    error_message = "failover_routing_policy.type must be PRIMARY or SECONDARY."
  }
}

variable "geolocation_routing_policy" {
  description = "Geolocation routing policy: `{ continent, country, subdivision }`. All three may be null but at least one MUST be set when this policy is used."
  type = object({
    continent   = optional(string)
    country     = optional(string)
    subdivision = optional(string)
  })
  default = null
}

variable "latency_routing_policy" {
  description = "Latency routing policy: `{ region = AWS region }`. Mutually exclusive with other routing policies."
  type = object({
    region = string
  })
  default = null
}

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
  description = "Record TTL in seconds. Required when alias is null. Ignored when alias is set. Must not be null."
  type        = number
  default     = 300
  nullable    = false

  validation {
    condition     = var.ttl >= 0
    error_message = "ttl must be >= 0."
  }
}

variable "records" {
  description = "List of record values (rdata). Required (non-empty) when alias is null; must be empty when alias is set. Cross-variable validation enforces this."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "alias" {
  description = "Alias target. When set, `ttl` and `records` are ignored. `{ name, zone_id, evaluate_target_health }`. Mutually exclusive with the records+ttl path."
  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = bool
  })
  default = null

  validation {
    condition     = (var.alias == null && length(var.records) > 0) || (var.alias != null && length(var.records) == 0)
    error_message = "Exactly one of `alias` (alias target) OR a non-empty `records` list must be configured. Setting both, or neither, is invalid."
  }
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
  description = "Weighted routing policy: `{ weight = number }`. Mutually exclusive with the other routing policies (validation enforced on this variable)."
  type = object({
    weight = number
  })
  default = null

  validation {
    condition = length([
      for p in [var.weighted_routing_policy, var.failover_routing_policy, var.geolocation_routing_policy, var.latency_routing_policy] : p if p != null
    ]) <= 1
    error_message = "At most one of weighted_routing_policy, failover_routing_policy, geolocation_routing_policy, latency_routing_policy may be set; they are mutually exclusive."
  }
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
  description = "Geolocation routing policy: `{ continent, country, subdivision }`. At least one of the three MUST be set when this policy is used."
  type = object({
    continent   = optional(string)
    country     = optional(string)
    subdivision = optional(string)
  })
  default = null

  validation {
    condition = (
      var.geolocation_routing_policy == null
      ) || (
      try(var.geolocation_routing_policy.continent, null) != null
      || try(var.geolocation_routing_policy.country, null) != null
      || try(var.geolocation_routing_policy.subdivision, null) != null
    )
    error_message = "geolocation_routing_policy must set at least one of continent, country, or subdivision."
  }
}

variable "latency_routing_policy" {
  description = "Latency routing policy: `{ region = AWS region }`. Mutually exclusive with other routing policies."
  type = object({
    region = string
  })
  default = null
}

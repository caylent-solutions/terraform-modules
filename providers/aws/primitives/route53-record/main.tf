resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = var.name
  type    = var.type
  ttl     = var.alias == null ? var.ttl : null
  records = var.alias == null ? var.records : null

  health_check_id = var.health_check_id

  set_identifier = var.set_identifier

  dynamic "alias" {
    for_each = var.alias == null ? [] : [var.alias]
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }

  dynamic "weighted_routing_policy" {
    for_each = var.weighted_routing_policy == null ? [] : [var.weighted_routing_policy]
    content {
      weight = weighted_routing_policy.value.weight
    }
  }

  dynamic "failover_routing_policy" {
    for_each = var.failover_routing_policy == null ? [] : [var.failover_routing_policy]
    content {
      type = failover_routing_policy.value.type
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = var.geolocation_routing_policy == null ? [] : [var.geolocation_routing_policy]
    content {
      continent   = geolocation_routing_policy.value.continent
      country     = geolocation_routing_policy.value.country
      subdivision = geolocation_routing_policy.value.subdivision
    }
  }

  dynamic "latency_routing_policy" {
    for_each = var.latency_routing_policy == null ? [] : [var.latency_routing_policy]
    content {
      region = latency_routing_policy.value.region
    }
  }
}

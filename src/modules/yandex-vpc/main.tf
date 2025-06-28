terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.85.0"
    }
  }
  required_version = ">= 1.3.0"
}

resource "yandex_vpc_network" "network" {
  name        = var.env_name
  description = var.network_description
  labels      = var.labels
}

resource "yandex_vpc_subnet" "subnets" {
  for_each       = { for subnet in var.subnets : "${subnet.zone}_${subnet.cidr}" => subnet }
  name           = "${var.env_name}-${each.value.zone}"
  description    = lookup(each.value, "description", "Subnet in zone ${each.value.zone}")
  zone           = each.value.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = [each.value.cidr]
  labels         = var.labels
}

resource "yandex_vpc_security_group" "main" {
  name        = "sg-${var.env_name}"
  description = "Security group for ${var.env_name} environment"
  network_id  = yandex_vpc_network.network.id
  labels      = var.labels

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      protocol       = ingress.value.protocol
      description    = ingress.value.description
      v4_cidr_blocks = ingress.value.v4_cidr_blocks
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      protocol       = egress.value.protocol
      description    = egress.value.description
      v4_cidr_blocks = egress.value.v4_cidr_blocks
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
    }
  }
}
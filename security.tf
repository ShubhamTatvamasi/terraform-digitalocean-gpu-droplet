resource "digitalocean_firewall" "gpu" {
  name        = "${var.project_name}-firewall"
  droplet_ids = [digitalocean_droplet.gpu.id]

  dynamic "inbound_rule" {
    for_each = var.firewall_ports
    content {
      protocol         = "tcp"
      port_range       = tostring(inbound_rule.value)
      source_addresses = var.allowed_cidrs
    }
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "droplet_id" {
  value = digitalocean_droplet.gpu.id
}

output "public_ip" {
  value = digitalocean_droplet.gpu.ipv4_address
}

output "public_ipv6" {
  value = digitalocean_droplet.gpu.ipv6_address
}

output "ssh_command" {
  value = "ssh root@${digitalocean_droplet.gpu.ipv4_address}"
}

output "public_ip" {
  value = digitalocean_droplet.gpu.ipv4_address
}

resource "digitalocean_droplet" "gpu" {
  name       = var.project_name
  region     = var.region
  size       = var.droplet_size
  image      = var.droplet_image
  ssh_keys   = [local.ssh_key_fingerprint]
  ipv6       = true
  monitoring = true
  tags       = var.tags
}

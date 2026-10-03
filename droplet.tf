resource "digitalocean_droplet" "gpu" {
  name       = var.project_name
  region     = var.region
  size       = var.droplet_size
  image      = var.droplet_image
  ssh_keys   = [digitalocean_ssh_key.ssh-key.fingerprint]
  monitoring = true
  tags       = var.tags
}

# Reuse a key already on the account (DigitalOcean rejects duplicate public keys),
# otherwise upload ssh_public_key_file.
data "digitalocean_ssh_key" "existing" {
  count = var.ssh_key_name != null ? 1 : 0
  name  = var.ssh_key_name
}

resource "digitalocean_ssh_key" "ssh_key" {
  count      = var.ssh_key_name == null ? 1 : 0
  name       = "${var.project_name}-key"
  public_key = file(pathexpand(var.ssh_public_key_file))
}

locals {
  ssh_key_fingerprint = var.ssh_key_name != null ? data.digitalocean_ssh_key.existing[0].fingerprint : digitalocean_ssh_key.ssh_key[0].fingerprint
}

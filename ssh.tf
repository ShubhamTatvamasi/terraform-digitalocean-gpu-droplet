# DigitalOcean rejects duplicate public keys, so reuse the key if it is already
# on the account and only upload it otherwise.
data "digitalocean_ssh_keys" "all" {}

locals {
  ssh_key_name = "${var.project_name}-key"
  # Compare "type base64" only, ignoring the trailing comment.
  ssh_public_key = join(" ", slice(split(" ", trimspace(file(pathexpand(var.ssh_public_key_file)))), 0, 2))

  # Skip the key managed below so it is not counted as pre-existing on the next run.
  existing_ssh_keys = [
    for k in data.digitalocean_ssh_keys.all.ssh_keys : k
    if k.name != local.ssh_key_name && join(" ", slice(split(" ", trimspace(k.public_key)), 0, 2)) == local.ssh_public_key
  ]

  ssh_key_fingerprint = length(local.existing_ssh_keys) > 0 ? local.existing_ssh_keys[0].fingerprint : digitalocean_ssh_key.ssh_key[0].fingerprint
}

resource "digitalocean_ssh_key" "ssh_key" {
  count      = length(local.existing_ssh_keys) > 0 ? 0 : 1
  name       = local.ssh_key_name
  public_key = local.ssh_public_key
}

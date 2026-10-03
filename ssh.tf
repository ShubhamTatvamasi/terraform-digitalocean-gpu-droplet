resource "random_uuid" "ssh_key_uuid" {}

resource "digitalocean_ssh_key" "ssh-key" {
  name       = "${var.project_name}-key-${random_uuid.ssh_key_uuid.result}"
  public_key = file("~/.ssh/id_ed25519.pub")
}

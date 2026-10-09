resource "digitalocean_ssh_key" "ssh_key" {
  name       = "${var.project_name}-key"
  public_key = file(pathexpand(var.ssh_public_key_file))
}

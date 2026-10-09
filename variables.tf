variable "project_name" {
  type        = string
  description = "Project name, used for the droplet, firewall and SSH key names"
  default     = "gpu-droplet"
}

variable "region" {
  type        = string
  description = "Region (GPU droplets are only available in some regions)"
  default     = "tor1"

  validation {
    condition     = contains(["nyc2", "tor1", "atl1", "ams3"], var.region)
    error_message = "GPU droplets are only available in nyc2, tor1, atl1 or ams3."
  }
}

variable "droplet_size" {
  type        = string
  description = "GPU droplet size slug (see `doctl compute size list | grep gpu`)"
  default     = "gpu-rtx4000x1-20gb"

  validation {
    condition     = startswith(var.droplet_size, "gpu-")
    error_message = "droplet_size must be a GPU size slug starting with \"gpu-\"."
  }
}

variable "droplet_image" {
  type        = string
  description = "OS image slug, e.g. ubuntu-26-04-x64 (plain Ubuntu) or gpu-h100x1-base (AI/ML Ready, drivers preinstalled)"
  default     = "ubuntu-26-04-x64"
}

variable "ssh_key_name" {
  type        = string
  description = "Name of an SSH key already on the DigitalOcean account to reuse. If null, ssh_public_key_file is uploaded."
  default     = null
}

variable "ssh_public_key_file" {
  type        = string
  description = "Path to the SSH public key added to the droplet"
  default     = "~/.ssh/id_ed25519.pub"
}

variable "firewall_ports" {
  type        = list(number)
  description = "Inbound TCP ports to open"
  default     = [22, 80, 443, 6443]
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "Source CIDRs allowed to reach the inbound ports (restrict to your IP, e.g. [\"203.0.113.10/32\"])"
  default     = ["0.0.0.0/0", "::/0"]
}

variable "tags" {
  type        = list(string)
  description = "Droplet tags"
  default     = ["gpu"]
}

variable "secrets_file" {
  type        = string
  description = "SOPS encrypted env file containing DIGITALOCEAN_TOKEN"
  default     = "~/secrets/cloud.env.enc"
}

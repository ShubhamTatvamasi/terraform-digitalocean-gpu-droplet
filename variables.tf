variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "gpu-droplet"
}

variable "region" {
  type        = string
  description = "Region (GPU droplets are only available in some regions, e.g. nyc2, tor1, atl1, ams3)"
  default     = "tor1"
}

variable "droplet_size" {
  type        = string
  description = "GPU Droplet Size"
  default     = "gpu-h100x1-80gb"
}

variable "droplet_image" {
  type        = string
  description = "Droplet Image (AI/ML-ready image with NVIDIA drivers and CUDA preinstalled)"
  default     = "gpu-h100x1-base"
}

variable "firewall_ports" {
  type        = list(number)
  description = "Firewall Inbound TCP Ports"
  default     = [22, 80, 443, 6443]
}

variable "tags" {
  type        = list(string)
  description = "Droplet Tags"
  default     = ["gpu"]
}

variable "secrets_file" {
  type        = string
  description = "SOPS encrypted env file containing DIGITALOCEAN_TOKEN"
  default     = "~/secrets/cloud.env.enc"
}

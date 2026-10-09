terraform {
  required_version = ">= 1.10"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.4"
    }
  }
}

provider "sops" {}

provider "digitalocean" {
  token = ephemeral.sops_file.secrets.data["DIGITALOCEAN_TOKEN"]
}

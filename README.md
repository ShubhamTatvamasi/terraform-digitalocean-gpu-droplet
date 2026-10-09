# terraform-digitalocean-gpu-droplet

The DigitalOcean API token is read from a [SOPS](https://github.com/getsops/sops) encrypted file (`~/secrets/cloud.env.enc` by default) using the [carlpett/sops](https://registry.terraform.io/providers/carlpett/sops/latest) provider. It is loaded as an ephemeral resource, so the token is never stored in the Terraform state.

Create the encrypted file:
```bash
echo "DIGITALOCEAN_TOKEN=dop_v1_xxxxxxxx" > cloud.env
sops encrypt --age $(age-keygen -y ~/.config/sops/age/keys.txt) \
  --input-type dotenv --output-type dotenv cloud.env > ~/secrets/cloud.env.enc
rm cloud.env
```

Point SOPS at your age key:
```bash
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
```

Initialize Terraform:
```bash
terraform init -upgrade
```

Create a GPU droplet (defaults: 1x RTX 4000 Ada on Ubuntu 26.04 LTS in `tor1`):
```bash
# Optional overrides
export TF_VAR_region=tor1
export TF_VAR_droplet_size=gpu-4000adax1-20gb
export TF_VAR_droplet_image=ubuntu-26-04-x64
export TF_VAR_allowed_cidrs='["'$(curl -s https://ifconfig.me)'/32"]'  # restrict inbound to your IP

terraform apply
```

### OS image

The OS is set by `droplet_image`:
- `ubuntu-26-04-x64` (default): plain Ubuntu 26.04 LTS, no GPU drivers. Install them after first login (see below).
- `gpu-h100x1-base` / `gpu-h100x8-base`: DigitalOcean's "AI/ML Ready" image, with NVIDIA drivers and CUDA already installed.
- `gpu-amd-base`: AI/ML Ready image for the AMD MI300X with ROCm.

Check which GPU sizes your account can use and in which regions (slugs and regions change often; the size slug must match exactly, e.g. RTX 4000 Ada is `gpu-4000adax1-20gb`):
```bash
doctl compute size list | grep gpu
doctl compute region list
doctl compute image list-distribution --public | grep -E "gpu|ubuntu"
```

Update terraform state file:
```bash
terraform apply -refresh-only
```

SSH into the droplet:
```bash
ssh root@$(terraform output -raw public_ip)
```

Install NVIDIA drivers (plain Ubuntu image only) and verify the GPU:
```bash
apt update && apt install -y ubuntu-drivers-common
ubuntu-drivers install && reboot

# after reconnecting
nvidia-smi
```

Destroy the droplet (GPU droplets are billed even when powered off):
```bash
terraform destroy -auto-approve
```

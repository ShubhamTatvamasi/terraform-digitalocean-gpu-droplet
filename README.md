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

Initalize Terraform:
```bash
terraform init -upgrade
```

Create a GPU droplet:
```bash
# Optional overrides
export TF_VAR_region=tor1
export TF_VAR_droplet_size=gpu-h100x1-80gb
export TF_VAR_droplet_image=gpu-h100x1-base

terraform apply -auto-approve
```

Available GPU sizes and images:
| GPU | Size | Image |
| --- | --- | --- |
| 1x NVIDIA H100 | `gpu-h100x1-80gb` | `gpu-h100x1-base` |
| 8x NVIDIA H100 | `gpu-h100x8-640gb` | `gpu-h100x8-base` |
| 1x NVIDIA L40S | `gpu-l40sx1-48gb` | `gpu-h100x1-base` |
| 1x NVIDIA RTX 4000 Ada | `gpu-rtx4000x1-20gb` | `gpu-h100x1-base` |
| 1x NVIDIA RTX 6000 Ada | `gpu-rtx6000adax1-48gb` | `gpu-h100x1-base` |
| 1x AMD MI300X | `gpu-mi300x1-192gb` | `gpu-amd-base` |

Check availability for your account:
```bash
doctl compute size list | grep gpu
doctl compute image list-distribution --public | grep gpu
```

Update terraform state file:
```bash
terraform refresh
```

SSH into the droplet:
```bash
ssh root@$(terraform output -raw public_ip)
```

Verify the GPU:
```bash
nvidia-smi
```

Destroy the droplet (GPU droplets are billed even when powered off):
```bash
terraform destroy -auto-approve
```

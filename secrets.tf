# Ephemeral: the decrypted token is never written to the Terraform state.
ephemeral "sops_file" "secrets" {
  source_file = pathexpand(var.secrets_file)
  input_type  = "dotenv"
}

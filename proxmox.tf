provider "proxmox" {
  endpoint  = var.proxmox_url
  api_token = var.proxmox_api_token_id != null ? "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}" : null
  username  = var.proxmox_username
  password  = var.proxmox_password
  insecure  = true
}

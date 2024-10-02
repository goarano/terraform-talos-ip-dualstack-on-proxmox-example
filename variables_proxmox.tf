variable proxmox_url {
  type = string
}

variable proxmox_api_token_id {
  type      = string
  sensitive = true
  default   = null
}

variable proxmox_api_token_secret {
  type      = string
  sensitive = true
  default   = null
}

variable proxmox_username {
  type      = string
  sensitive = true
  default   = null
}

variable proxmox_password {
  type      = string
  sensitive = true
  default   = null
}

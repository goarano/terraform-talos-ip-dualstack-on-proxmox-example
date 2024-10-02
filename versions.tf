terraform {
  required_version = ">= 1.3.7"

  required_providers {
    local = {
      source = "hashicorp/local"
      version = "~> 2.5.2"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.6.3"
    }
    time = {
      source = "hashicorp/time"
      version = "~> 0.12.1"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.65.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.6.0"
    }
  }
}

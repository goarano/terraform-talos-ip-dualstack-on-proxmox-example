resource "random_string" "talos_worker_node_id" {
  count = var.worker_nodes

  length  = 6
  upper   = false
  special = false
}

module "talos_worker_mac_address" {
  count = var.worker_nodes

  source  = "goarano/mac-address/random"
  version = "0.0.5"
}

resource "proxmox_virtual_environment_vm" "talos_worker" {
  count = var.worker_nodes

  name        = format("talos-work-%s-%s",
    substr(random_string.talos_worker_node_id[count.index].result, 0, 3),
    substr(random_string.talos_worker_node_id[count.index].result, 3, 3)
  )
  description = "Managed by Terraform"
  tags        = ["terraform", "talos", "worker"]

  node_name = var.pve_node
  vm_id     = 735 + count.index

  agent {
    enabled = true
  }

  cpu {
    cores = "4"
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 4096
  }

  cdrom {
    enabled = true
    file_id = proxmox_virtual_environment_download_file.talos_image.id
  }

  disk {
    datastore_id = "local-zfs"
    file_format  = "raw"
    interface    = "scsi0"
    size         = 50
    ssd          = "true"
  }

  network_device {
    bridge      = "vmbr0"
    mac_address = module.talos_worker_mac_address[count.index].mac_address
  }

  operating_system {
    type = "l26"  # Linux >= 2.6
  }

  lifecycle {
    ignore_changes = [
      cdrom,
    ]
  }
}

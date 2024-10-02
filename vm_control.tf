resource "random_string" "talos_control_node_id" {
  count = var.control_nodes

  length  = 6
  upper   = false
  special = false
}

module "talos_control_mac_address" {
  count = var.control_nodes

  source  = "goarano/mac-address/random"
  version = "0.0.4"
}

resource "proxmox_virtual_environment_vm" "talos_control" {
  count = var.control_nodes

  name        = format("talos-ctrl-%s-%s",
    substr(random_string.talos_control_node_id[count.index].result, 0, 3),
    substr(random_string.talos_control_node_id[count.index].result, 3, 3)
  )
  description = "Managed by Terraform"
  tags        = ["terraform", "talos", "controlplane"]

  node_name = var.pve_node
  vm_id     = 730 + count.index

  agent {
    enabled = true
  }

  cpu {
    cores = "2"
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
  }

  cdrom {
    enabled = true
    file_id = proxmox_virtual_environment_download_file.talos_image.id
  }

  disk {
    datastore_id = "local-zfs"
    file_format  = "raw"
    interface    = "scsi0"
    size         = 10
    ssd          = "true"
  }

  network_device {
    bridge      = "vmbr0"
    mac_address = module.talos_control_mac_address[count.index].mac_address
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

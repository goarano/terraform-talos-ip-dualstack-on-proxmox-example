locals {
  worker_ipv4_addresses = [for i, vm in proxmox_virtual_environment_vm.talos_worker :
    element(vm.ipv4_addresses,
    index(vm.network_interface_names, module.talos_worker_mac_address[i].interface_name)
  )[0]]
  worker_ipv6_addresses = [for i, vm in proxmox_virtual_environment_vm.talos_worker :
    element(vm.ipv6_addresses,
    index(vm.network_interface_names, module.talos_worker_mac_address[i].interface_name)
  )[0]]
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = "https://[${local.control_plane_address}]:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = [
    terraform_data.talos_config_cluster.output,
    #terraform_data.talos_config_cluster_ccm.output,
    #terraform_data.talos_config_ccm.output,
  ]
}

data "talos_machine_disks" "worker" {
  count = var.worker_nodes

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.worker_ipv4_addresses[count.index]

  filters = {
    size = ">= 50GB"
    type = "ssd"
  }
}

resource "talos_machine_configuration_apply" "worker" {
  count = var.worker_nodes

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = local.worker_ipv4_addresses[count.index]

  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = proxmox_virtual_environment_vm.talos_worker[count.index].name
        }
        install = {
          disk  = data.talos_machine_disks.worker[count.index].disks[0].name
          image = terraform_data.cd_image.output
        }
      }
    }),
  ]
}

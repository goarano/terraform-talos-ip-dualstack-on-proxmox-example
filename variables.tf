variable pve_node {
  type        = string
  description = "Proxmox node to deploy to"
}

variable talos_version {
  type    = string
  default = "v1.8.0"
}

variable cluster_name {
  type    = string
  default = "talos-dualstack-example"
}

variable vm_name_prefix {
  type    = string
  default = "talos"
}

variable control_nodes {
  type    = number
  default = 2
}

variable worker_nodes {
  type    = number
  default = 2
}

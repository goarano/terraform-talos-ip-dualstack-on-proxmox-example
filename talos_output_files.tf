resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.control_plane_address

  depends_on = [
    talos_machine_bootstrap.this
  ]
}

data "talos_cluster_health" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = local.control_plane_ipv4_addresses # IPv6 does not work here

  control_plane_nodes = local.control_plane_ipv4_addresses  # IPv6 does not work here
  worker_nodes        = local.worker_ipv4_addresses         # IPv6 does not work here

  depends_on = [
    talos_machine_bootstrap.this
  ]
}

resource "local_sensitive_file" "kubeconfig" {
  filename = "${path.module}/out/kubeconfig"
  content  = talos_cluster_kubeconfig.this.kubeconfig_raw

  depends_on = [
    data.talos_cluster_health.this
  ]
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}

data "talos_client_configuration" "this" {
  cluster_name         = "example-cluster"
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = concat(
    local.control_plane_ipv6_addresses,
    local.worker_ipv6_addresses,
  )
  endpoints            = local.control_plane_ipv6_addresses
}

resource "local_sensitive_file" "talos_config" {
  filename = "${path.module}/out/talosconfig"
  content  = data.talos_client_configuration.this.talos_config
}

resource "local_sensitive_file" "machine_config_control" {
  filename = "${path.module}/out/machine_config_control.yaml"
  content   = data.talos_machine_configuration.control.machine_configuration
}

resource "local_sensitive_file" "machine_config_worker" {
  filename = "${path.module}/out/machine_config_worker.yaml"
  content   = data.talos_machine_configuration.worker.machine_configuration
}

resource "local_sensitive_file" "machine_config_control0" {
  filename = "${path.module}/out/machine_config_control0.yaml"
  content   = talos_machine_configuration_apply.control[0].machine_configuration
}

resource "local_sensitive_file" "machine_config_worker0" {
  filename = "${path.module}/out/machine_config_worker0.yaml"
  content   = talos_machine_configuration_apply.worker[0].machine_configuration
}

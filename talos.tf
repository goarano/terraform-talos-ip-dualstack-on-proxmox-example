resource "talos_machine_secrets" "this" {}

# bootstrapping too early can cause it to never finish
resource "time_sleep" "wait_before_bootstrap" {
  create_duration = "5s"

  depends_on = [
    talos_machine_configuration_apply.control[0]
  ]
}

resource "talos_machine_bootstrap" "this" {
  node                 = local.control_plane_ipv6_addresses[0]
  client_configuration = talos_machine_secrets.this.client_configuration

  depends_on = [
    talos_machine_configuration_apply.control[0],
    time_sleep.wait_before_bootstrap,
  ]
}

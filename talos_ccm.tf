# This is work in progress

resource "terraform_data" "talos_config_cluster_ccm" {
  input = yamlencode({
    cluster = {
      externalCloudProvider = {
        enabled = true
        manifests = [
          "https://raw.githubusercontent.com/siderolabs/talos-cloud-controller-manager/main/docs/deploy/cloud-controller-manager.yml"
        ]
      }
    }
  })
}

resource "terraform_data" "talos_config_machine_ccm_control" {
  input = yamlencode({
    machine = {
      features = {
        kubernetesTalosAPIAccess = {
          enabled                     = true
          allowedRoles                = [ "os:reader" ]
          allowedKubernetesNamespaces = [ "kube-system" ]
        }
      }
    }
  })
}

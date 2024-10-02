module "talos_control_ipv6_subnet_pod" {
  source  = "goarano/ipv6-subnet/random"
  version = "0.0.4"

  prefix = 64
}

module "talos_control_ipv6_subnet_service" {
  source  = "goarano/ipv6-subnet/random"
  version = "0.0.4"

  prefix = 108
}

resource "terraform_data" "talos_config_cluster" {
  input = yamlencode({
    cluster = {
      network = {
        podSubnets = [
          module.talos_control_ipv6_subnet_pod.subnet,
          "10.244.0.0/16"
        ]
        serviceSubnets = [
          module.talos_control_ipv6_subnet_service.subnet,
          "10.96.0.0/12"
        ]
      }
      controllerManager = {
        extraArgs = {
          node-cidr-mask-size-ipv6 = "80"
        }
      }
    }
  })
}

resource "terraform_data" "talos_config_machine_ccm" {
  input = yamlencode({
    machine = {
      kubelet = {
        extraArgs = {
          cloud-provider             = "external"
          rotate-server-certificates = true
        }
      }
    }
  })
}

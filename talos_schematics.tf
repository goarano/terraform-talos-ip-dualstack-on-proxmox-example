data "talos_image_factory_extensions_versions" "this" {
  talos_version = var.talos_version

  filters = {
    names = [
      "qemu-guest-agent",
      #"iscsi-tools",
      #"util-linux-tools",
    ]
  }
}

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode({
      customization = {
        systemExtensions = {
          officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info.*.name
        }
      }
    }
  )
}

resource "terraform_data" "cd_image" {
  input = format("factory.talos.dev/installer/%s:%s",
    talos_image_factory_schematic.this.id,
    var.talos_version
  )
}

output "talos_schematic_id" {
  value = talos_image_factory_schematic.this.id
}

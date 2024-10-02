resource "proxmox_virtual_environment_download_file" "talos_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.pve_node
  url          = format("https://factory.talos.dev/image/%s/%s/metal-amd64.iso",
                   talos_image_factory_schematic.this.id,
                   var.talos_version
                 )
  file_name    = format("talos-%s-metal-amd64.iso", var.talos_version)
}

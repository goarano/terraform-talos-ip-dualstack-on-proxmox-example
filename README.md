# terraform-talos-ip-dualstack-on-proxmox-example

Working example deployment of Talos with IPv4/IPv6 dual stack on Proxmox.

## Motivation

For my homelab I wanted to deploy a Kubernetes cluster on a handful of small factor PCs.
Previously I had used k3s on bare metal, but didn't quite like the manual process of upgrading the nodes.
Therefore I decided on using [Talos](https://www.talos.dev/) as my Kubernetes distribution.
Since my new setup requires wiping all my current PCs I decided on installing everything on VMs within [Proxmox](https://www.proxmox.com/) this time instead.

Furthermore it was near impossible to find information on how to deploy Talos with IPv4/IPv6 multistack.
Since having IPv6 available in 2024 is a basic requirement to me, I decided to figure out how to deploy it in a reproducable way and am publishing my results in this repo.

## Setup

### Proxmox provider

You can connect to your proxmox instance either using a username and password or via the API, in any case `var.endpoint` needs to be configured to point to your proxmox instance.
For the former you need to set `var.proxmox_username` and `var.proxmox_password`, the latter requires `var.proxmox_api_token_id` and `var.proxmox_api_token_secret`.

```tfvars
proxmox_url = "https://proxmox.host:8006"
proxmox_username = "root@pam"
proxmox_password = "admin123"
```


An example how to create the API token ID and secret can be seen below.

```bash
pveum user add terraform-prov@pve
pveum aclmod / -user terraform-prov@pve -role TerraformProv
pveum user token add terraform-prov@pve workstation --privsep=0
pveum role modify TerraformProv -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify SDN.Use VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt User.Modify Realm.AllocateUser"
```

### Further required configuration

The last required configuration is `var.pve_node`, which needs to be set to the name of the proxmox node where the VMs should be deployed.

## Structure

* `talos*.tf`: talos configuration
    * `talos_output_files.tf`: creates tf outputs and files in ./out/ to be able to inspect and use talos outside of terraform
    * `talos_ccm.tf`: integration of the talos cloud control manager (unfinished)
    * `talos_vm_*.tf`: configurations for the control plane and workers
    * `talos_schematics.tf`: programmatic retrieval of the talos image fromt the factory
* `vm.tf`: proxmox VM configurations; specifically the talos ISO image
    * `vm_*.tf`: proxmox VM configurations of the control plane and workers

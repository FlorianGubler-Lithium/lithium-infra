#########################
# SDN Backend Zone (Datacenter Level)
#########################

resource "proxmox_virtual_environment_sdn_applier" "finalizer" {
}

resource "proxmox_virtual_environment_sdn_zone_vlan" "backend" {
  id = "backend"
  bridge = "vmbr0"
  ipam = "pve"

  depends_on = [
    proxmox_virtual_environment_sdn_applier.finalizer
  ]
}

#########################
# Virtual Networks (vnets) in Backend Zone
#########################

resource "proxmox_virtual_environment_sdn_vnet" "dev" {
  zone       = proxmox_virtual_environment_sdn_zone_vlan.backend.id
  id       = "dev"
  tag     = 100

  depends_on = [
    proxmox_virtual_environment_sdn_applier.finalizer
  ]
}

resource "proxmox_virtual_environment_sdn_vnet" "prod" {
  zone       = proxmox_virtual_environment_sdn_zone_vlan.backend.id
  id       = "prod"
  tag     = 200

  depends_on = [
    proxmox_virtual_environment_sdn_applier.finalizer
  ]
}

resource "proxmox_virtual_environment_sdn_vnet" "infra" {
  zone       = proxmox_virtual_environment_sdn_zone_vlan.backend.id
  id       = "infra"
  tag     = 300

  depends_on = [
    proxmox_virtual_environment_sdn_applier.finalizer
  ]
}

#########################
# SDN Applier
#########################

resource "proxmox_virtual_environment_sdn_applier" "sdn_applier" {
  depends_on = [
    proxmox_virtual_environment_sdn_zone_vlan.backend,
    proxmox_virtual_environment_sdn_vnet.dev,
    proxmox_virtual_environment_sdn_vnet.prod,
    proxmox_virtual_environment_sdn_vnet.infra,
  ]

  lifecycle {
    replace_triggered_by = [
      proxmox_virtual_environment_sdn_zone_vlan.backend,
      proxmox_virtual_environment_sdn_vnet.dev,
      proxmox_virtual_environment_sdn_vnet.prod,
      proxmox_virtual_environment_sdn_vnet.infra,
    ]
  }
}


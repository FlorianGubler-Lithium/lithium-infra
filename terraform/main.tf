terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">=2.9"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = "terraform@pve!terraform-access"
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true
}

#########################
# Network Zones (VLAN)
#########################

locals {

  zones = {
    devzone = {
      vlan = 100
      subnet = "10.10.0.0/24"
      gateway = "10.10.0.1"
    }

    prodzone = {
      vlan = 200
      subnet = "10.20.0.0/24"
      gateway = "10.20.0.1"
    }

    infrazone = {
      vlan = 300
      subnet = "10.30.0.0/24"
      gateway = "10.30.0.1"
    }
  }

}

#########################
# VM IP Assignments
#########################

locals {
  vm_ips = {
    # Dev zone VMs (starting at 10.10.0.10)
    "kube-dev-master-001" = "10.10.0.10"
    "kube-dev-worker-001" = "10.10.0.11"

    # Prod zone VMs (starting at 10.20.0.10)
    "kube-prod-master-001" = "10.20.0.10"
    "kube-prod-worker-001" = "10.20.0.11"

    # Infra zone VMs (starting at 10.30.0.10)
    "jump-001" = "10.30.0.10"
    "proxy-001" = "10.30.0.11"
    "mgmt-001" = "10.30.0.12"
  }
}

#########################
# Firewall Router VM
#########################

resource "proxmox_vm_qemu" "firewall" {

  name        = "cluster-firewall"
  target_node = var.pm_node
  iso         = var.debian_iso

  vmid  = 100
  cores = 2
  memory = 4096

  boot = "order=virtio0;ide2"

  agent = 1

  # Root disk
  virtio {
    id           = 0
    iothread     = 1
    cache        = "writeback"
    size         = "50G"
    storage      = "local-lvm"
    file_format  = "raw"
  }

  # CD-ROM for ISO
  ide {
    id       = 2
    media    = "cdrom"
    file     = var.debian_iso
  }

  # Management interface
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  # Dev zone interface
  network {
    bridge = "vmbr0"
    tag    = local.zones.devzone.vlan
    model  = "virtio"
  }

  # Prod zone interface
  network {
    bridge = "vmbr0"
    tag    = local.zones.prodzone.vlan
    model  = "virtio"
  }

  # Infra zone interface
  network {
    bridge = "vmbr0"
    tag    = local.zones.infrazone.vlan
    model  = "virtio"
  }

  ciuser       = "debian"
  cicustom     = "user=${proxmox_cloud_init_config.firewall.id}"
  cloudinit_cdrom_storage = "local-lvm"

  lifecycle {
    ignore_changes = [
      ciuser,
      cicustom,
      cloudinit_cdrom_storage,
    ]
  }

}

############################
# VM Definitions
############################

locals {

  dev_vms = {
    kube-dev-master-001 = { zone = "devzone", role = "master" }
    kube-dev-worker-001 = { zone = "devzone", role = "worker" }
  }

  prod_vms = {
    kube-prod-master-001 = { zone = "prodzone", role = "master" }
    kube-prod-worker-001 = { zone = "prodzone", role = "worker" }
  }

  infra_vms = {
    jump-001 = { zone = "infrazone", role = "jump" }
    proxy-001 = { zone = "infrazone", role = "proxy" }
    mgmt-001 = { zone = "infrazone", role = "mgmt" }
  }
}

resource "proxmox_vm_qemu" "dev_vms" {

  for_each = local.dev_vms

  name        = each.key
  target_node = var.pm_node
  iso         = var.debian_iso

  vmid   = 1000 + index(sort(keys(local.dev_vms)), each.key)
  cores  = 2
  memory = 4096

  boot = "order=virtio0;ide2"

  agent = 1

  # Root disk
  virtio {
    id           = 0
    iothread     = 1
    cache        = "writeback"
    size         = "50G"
    storage      = "local-lvm"
    file_format  = "raw"
  }

  # CD-ROM for ISO
  ide {
    id       = 2
    media    = "cdrom"
    file     = var.debian_iso
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = local.zones.devzone.vlan
  }

  ciuser       = "debian"
  cicustom     = "user=${proxmox_cloud_init_config.dev_vms[each.key].id}"
  cloudinit_cdrom_storage = "local-lvm"

  lifecycle {
    ignore_changes = [
      ciuser,
      cicustom,
      cloudinit_cdrom_storage,
    ]
  }

}

resource "proxmox_vm_qemu" "prod_vms" {

  for_each = local.prod_vms

  name        = each.key
  target_node = var.pm_node
  iso         = var.debian_iso

  vmid   = 2000 + index(sort(keys(local.prod_vms)), each.key)
  cores  = 2
  memory = 4096

  boot = "order=virtio0;ide2"

  agent = 1

  # Root disk
  virtio {
    id           = 0
    iothread     = 1
    cache        = "writeback"
    size         = "50G"
    storage      = "local-lvm"
    file_format  = "raw"
  }

  # CD-ROM for ISO
  ide {
    id       = 2
    media    = "cdrom"
    file     = var.debian_iso
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = local.zones.prodzone.vlan
  }

  ciuser       = "debian"
  cicustom     = "user=${proxmox_cloud_init_config.prod_vms[each.key].id}"
  cloudinit_cdrom_storage = "local-lvm"

  lifecycle {
    ignore_changes = [
      ciuser,
      cicustom,
      cloudinit_cdrom_storage,
    ]
  }

}

resource "proxmox_vm_qemu" "infra_vms" {

  for_each = local.infra_vms

  name        = each.key
  target_node = var.pm_node
  iso         = var.debian_iso

  vmid   = 3000 + index(sort(keys(local.infra_vms)), each.key)
  cores  = 2
  memory = 4096

  boot = "order=virtio0;ide2"

  agent = 1

  # Root disk
  virtio {
    id           = 0
    iothread     = 1
    cache        = "writeback"
    size         = "50G"
    storage      = "local-lvm"
    file_format  = "raw"
  }

  # CD-ROM for ISO
  ide {
    id       = 2
    media    = "cdrom"
    file     = var.debian_iso
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = local.zones.infrazone.vlan
  }

  ciuser       = "debian"
  cicustom     = "user=${proxmox_cloud_init_config.infra_vms[each.key].id}"
  cloudinit_cdrom_storage = "local-lvm"

  lifecycle {
    ignore_changes = [
      ciuser,
      cicustom,
      cloudinit_cdrom_storage,
    ]
  }

}

#########################
# Cloud-init Configs
#########################

resource "proxmox_cloud_init_config" "firewall" {
  name             = "firewall-cloud-init"
  target_node      = var.pm_node
  vmid             = proxmox_vm_qemu.firewall.vmid
  user_data_base64 = base64encode(templatefile("${path.module}/firewall-cloud-init.yaml", {
    hostname       = "cluster-firewall"
    ssh_public_key = var.ssh_public_key
    vm_password    = var.vm_password
    dns_servers    = join(" ", var.dns_servers)
  }))
}

resource "proxmox_cloud_init_config" "dev_vms" {
  for_each = local.dev_vms

  name             = "dev-${each.key}-cloud-init"
  target_node      = var.pm_node
  vmid             = 1000 + index(sort(keys(local.dev_vms)), each.key)
  user_data_base64 = base64encode(templatefile("${path.module}/vm-cloud-init.yaml", {
    hostname       = each.key
    ssh_public_key = var.ssh_public_key
    vm_password    = var.vm_password
    dns_servers    = join(" ", var.dns_servers)
    static_ip      = local.vm_ips[each.key]
    gateway_ip     = local.zones.devzone.gateway
  }))
}

resource "proxmox_cloud_init_config" "prod_vms" {
  for_each = local.prod_vms

  name             = "prod-${each.key}-cloud-init"
  target_node      = var.pm_node
  vmid             = 2000 + index(sort(keys(local.prod_vms)), each.key)
  user_data_base64 = base64encode(templatefile("${path.module}/vm-cloud-init.yaml", {
    hostname       = each.key
    ssh_public_key = var.ssh_public_key
    vm_password    = var.vm_password
    dns_servers    = join(" ", var.dns_servers)
    static_ip      = local.vm_ips[each.key]
    gateway_ip     = local.zones.prodzone.gateway
  }))
}

resource "proxmox_cloud_init_config" "infra_vms" {
  for_each = local.infra_vms

  name             = "infra-${each.key}-cloud-init"
  target_node      = var.pm_node
  vmid             = 3000 + index(sort(keys(local.infra_vms)), each.key)
  user_data_base64 = base64encode(templatefile("${path.module}/vm-cloud-init.yaml", {
    hostname       = each.key
    ssh_public_key = var.ssh_public_key
    vm_password    = var.vm_password
    dns_servers    = join(" ", var.dns_servers)
    static_ip      = local.vm_ips[each.key]
    gateway_ip     = local.zones.infrazone.gateway
  }))
}

variable "pm_node" {}
variable "vm_password" { sensitive = true }
variable "ssh_public_key" { sensitive = true }
variable "dns_servers" {}
variable "debian_cloud_image_id" {}
variable "sdn_applier" {}

resource "proxmox_virtual_environment_file" "user_config" {
  node_name    = var.pm_node
  datastore_id = "local"
  content_type = "snippets"

  source_raw {
    file_name = "kube-prod-master-001-cloud-init.yaml"
    data = templatefile("${path.module}/userdata.yaml", {
      hostname       = "kube-prod-master-001"
      vm_password    = var.vm_password
      dns_servers    = jsonencode(var.dns_servers)
      ssh_public_key = var.ssh_public_key
    })
  }

  depends_on = [var.sdn_applier]
}

resource "proxmox_virtual_environment_file" "network_config" {
  node_name    = var.pm_node
  datastore_id = "local"
  content_type = "snippets"

  source_raw {
    file_name = "kube-prod-master-001-network.yaml"
    data      = file("${path.module}/network.yaml")
  }

  depends_on = [var.sdn_applier]
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = "kube-prod-master-001"
  node_name = var.pm_node
  vm_id     = 2001

  memory { dedicated = 4096 }

  initialization {
    user_data_file_id    = proxmox_virtual_environment_file.user_config.id
    network_data_file_id = proxmox_virtual_environment_file.network_config.id
  }

  keyboard_layout = "de-ch"
  boot_order      = ["ide2", "scsi0"]
  agent { enabled = true }
  cpu { cores = 2 }

  disk {
    datastore_id = "local-lvm"
    file_id      = var.debian_cloud_image_id
    interface    = "scsi0"
    size         = 20
  }

  network_device {
    bridge = "prod"
    model  = "virtio"
  }

  depends_on = [var.sdn_applier]
}

output "vm" { value = proxmox_virtual_environment_vm.vm }


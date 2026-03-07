provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

# Example VM creation
resource "proxmox_vm_qemu" "k8s_master" {
  name   = "k8s-master-01"
  cores  = 4
  memory = 8192
  disk {
    size = "50G"
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  os_type   = "cloud-init"
  ssh_keys  = file("~/.ssh/id_rsa.pub")
  iso       = "local:iso/ubuntu-24.04.iso"
}

resource "proxmox_vm_qemu" "k8s_worker" {
  count  = 2
  name   = "k8s-worker-${count.index + 1}"
  cores  = 2
  memory = 4096
  disk {
    size = "40G"
  }
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
  os_type  = "cloud-init"
  ssh_keys = file("~/.ssh/id_rsa.pub")
  iso      = "local:iso/ubuntu-24.04.iso"
}

# Trigger Ansible bootstrap
resource "null_resource" "bootstrap_k8s" {
  depends_on = [
    proxmox_vm_qemu.k8s_master,
    proxmox_vm_qemu.k8s_worker
  ]

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/playbooks/bootstrap-k8s.yml"
  }
}
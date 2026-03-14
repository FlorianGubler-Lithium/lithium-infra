#########################
# Cloud-init Configuration Files
#########################

resource "proxmox_virtual_environment_file" "cloud_user_config" {
  for_each = local.all_vms

  node_name = var.pm_node
  datastore_id = "local"

  content_type = "snippets"

  source_raw {
    file_name = "ci-${each.key}-userdata.yaml"
    data = templatefile("${path.module}/cloud-init/${each.key}/userdata.yaml", {
      hostname      = each.key
      vm_password   = var.vm_password
      dns_servers   = jsonencode(var.dns_servers)
      ssh_public_key = var.ssh_public_key
    })
  }
}

resource "proxmox_virtual_environment_file" "cloud_network_config" {
  for_each = local.all_vms

  node_name = var.pm_node
  datastore_id = "local"

  content_type = "snippets"

  source_raw {
    file_name = "ci-${each.key}-network.yaml"
    data = file("${path.module}/cloud-init/${each.key}/network.yaml")
  }
}

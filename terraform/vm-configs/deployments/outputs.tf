output "deployment_vms" {
  description = "All deployment VMs with their metadata for Ansible inventory"
  value = {
    for k, m in module.deployment_vms : k => m.vm_metadata
  }
}


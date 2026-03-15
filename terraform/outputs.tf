# Terraform Outputs for Kubernetes Infrastructure

#########################
# Infra VM Outputs
#########################

output "proxy_vm" {
  description = "Proxy VM details"
  value = {
    vmid = module.infra_vms.proxy_vm.vm.vm_id
    name = module.infra_vms.proxy_vm.vm.name
  }
}

output "firewall_vm" {
  description = "Firewall VM details"
  value = {
    vmid = module.infra_vms.firewall_vm.vm.vm_id
    name = module.infra_vms.firewall_vm.vm.name
  }
}

output "jump_vm" {
  description = "Jump VM details"
  value = {
    vmid = module.infra_vms.jump_vm.vm.vm_id
    name = module.infra_vms.jump_vm.vm.name
  }
}


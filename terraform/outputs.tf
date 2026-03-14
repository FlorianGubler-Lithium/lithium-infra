# Terraform Outputs for Kubernetes Infrastructure

#########################
# Proxy VM Outputs
#########################

output "proxy_001" {
  description = "Proxy VM details"
  value = {
    vmid = module.proxy_001.vm.vm_id
    name = module.proxy_001.vm.name
  }
}

#########################
# Firewall VM Outputs
#########################

output "firewall_001" {
  description = "Firewall VM details"
  value = {
    vmid = module.firewall_001.vm.vm_id
    name = module.firewall_001.vm.name
  }
}

#########################
# Jump VM Outputs
#########################

# output "jump_001" {
#   description = "Jump VM details"
#   value = {
#     vmid = module.jump_001.vm.vm_id
#     name = module.jump_001.vm.name
#   }
# }
#
# #########################
# # Dev Zone VM Outputs
# #########################
#
# output "kube_dev_master_001" {
#   description = "Kubernetes Dev Master VM details"
#   value = {
#     vmid = module.kube_dev_master_001.vm.vm_id
#     name = module.kube_dev_master_001.vm.name
#   }
# }
#
# output "kube_dev_worker_001" {
#   description = "Kubernetes Dev Worker VM details"
#   value = {
#     vmid = module.kube_dev_worker_001.vm.vm_id
#     name = module.kube_dev_worker_001.vm.name
#   }
# }
#
# output "mgmt_dev_001" {
#   description = "Management Dev VM details"
#   value = {
#     vmid = module.mgmt_dev_001.vm.vm_id
#     name = module.mgmt_dev_001.vm.name
#   }
# }
#
# #########################
# # Prod Zone VM Outputs
# #########################
#
# output "kube_prod_master_001" {
#   description = "Kubernetes Prod Master VM details"
#   value = {
#     vmid = module.kube_prod_master_001.vm.vm_id
#     name = module.kube_prod_master_001.vm.name
#   }
# }
#
# output "kube_prod_worker_001" {
#   description = "Kubernetes Prod Worker VM details"
#   value = {
#     vmid = module.kube_prod_worker_001.vm.vm_id
#     name = module.kube_prod_worker_001.vm.name
#   }
# }
#
# output "mgmt_prod_001" {
#   description = "Management Prod VM details"
#   value = {
#     vmid = module.mgmt_prod_001.vm.vm_id
#     name = module.mgmt_prod_001.vm.name
#   }
# }
#
# #########################
# # All VMs Summary
# #########################
#
# output "all_vms" {
#   description = "Summary of all deployed VMs"
#   value = {
#     infra = {
#       proxy_001 = {
#         vmid = module.proxy_001.vm.vm_id
#         name = module.proxy_001.vm.name
#       }
#     }
#     firewall = {
#       firewall_001 = {
#         vmid = module.firewall_001.vm.vm_id
#         name = module.firewall_001.vm.name
#       }
#     }
#     dev = {
#       jump = {
#         vmid = module.jump_001.vm.vm_id
#         name = module.jump_001.vm.name
#       }
#       master = {
#         vmid = module.kube_dev_master_001.vm.vm_id
#         name = module.kube_dev_master_001.vm.name
#       }
#       worker = {
#         vmid = module.kube_dev_worker_001.vm.vm_id
#         name = module.kube_dev_worker_001.vm.name
#       }
#       mgmt = {
#         vmid = module.mgmt_dev_001.vm.vm_id
#         name = module.mgmt_dev_001.vm.name
#       }
#     }
#     prod = {
#       master = {
#         vmid = module.kube_prod_master_001.vm.vm_id
#         name = module.kube_prod_master_001.vm.name
#       }
#       worker = {
#         vmid = module.kube_prod_worker_001.vm.vm_id
#         name = module.kube_prod_worker_001.vm.name
#       }
#       mgmt = {
#         vmid = module.mgmt_prod_001.vm.vm_id
#         name = module.mgmt_prod_001.vm.name
#       }
#     }
#   }
# }
# #

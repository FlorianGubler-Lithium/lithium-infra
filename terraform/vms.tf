############################
# Proxy VM Module
############################

module "proxy_001" {
  source = "./vm-config/proxy-001"

  pm_node               = var.pm_node
  vm_password           = var.vm_password
  ssh_public_key        = var.ssh_public_key
  dns_servers           = var.dns_servers
  debian_cloud_image_id = proxmox_virtual_environment_download_file.debian_cloud_image.id
  sdn_applier           = proxmox_virtual_environment_sdn_applier.sdn_applier
}

############################
# Firewall VM Module
############################

module "firewall_001" {
  source = "./vm-config/firewall-001"

  pm_node               = var.pm_node
  vm_password           = var.vm_password
  ssh_public_key        = var.ssh_public_key
  dns_servers           = var.dns_servers
  debian_cloud_image_id = proxmox_virtual_environment_download_file.debian_cloud_image.id
  sdn_applier           = proxmox_virtual_environment_sdn_applier.sdn_applier
}

# ############################
# # Jump VM Module
# ############################
#
# module "jump_001" {
#   source = "./vm-config/jump-001"
#
#   pm_node               = var.pm_node
#   vm_password           = var.vm_password
#   ssh_public_key        = var.ssh_public_key
#   dns_servers           = var.dns_servers
#   debian_cloud_image_id = proxmox_virtual_environment_download_file.debian_cloud_image.id
#   sdn_applier           = proxmox_virtual_environment_sdn_applier.sdn_applier
#
#   depends_on = [module.firewall_001]
# }
#
# ############################
# # Kube Dev Master VM Module
# ############################
#
# module "kube_dev_master_001" {
#   source = "./vm-config/kube-dev-master-001"
#
#   pm_node               = var.pm_node
#   vm_password           = var.vm_password
#   ssh_public_key        = var.ssh_public_key
#   dns_servers           = var.dns_servers
#   debian_cloud_image_id = proxmox_virtual_environment_download_file.debian_cloud_image.id
#   sdn_applier           = proxmox_virtual_environment_sdn_applier.sdn_applier
#
#   depends_on = [module.firewall_001]
# }
#
# ############################
# # Kube Dev Worker VM Module
# ############################
#
# module "kube_dev_worker_001" {
#   source = "./vm-config/kube-dev-worker-001"
#
#   pm_node               = var.pm_node
#   vm_password           = var.vm_password
#   ssh_public_key        = var.ssh_public_key
#   dns_servers           = var.dns_servers
#   debian_cloud_image_id = proxmox_virtual_environment_download_file.debian_cloud_image.id
#   sdn_applier           = proxmox_virtual_environment_sdn_applier.sdn_applier
#
#   depends_on = [module.kube_dev_master_001]
# }
#
# ############################
# # Management Dev VM Module
# ############################
#
# module "mgmt_dev_001" {
#   source = "./vm-config/mgmt-dev-001"
#
#   pm_node               = var.pm_node
#   vm_password           = var.vm_password
#   ssh_public_key        = var.ssh_public_key
#   dns_servers           = var.dns_servers
#   debian_cloud_image_id = proxmox_virtual_environment_download_file.debian_cloud_image.id
#   sdn_applier           = proxmox_virtual_environment_sdn_applier.sdn_applier
#
#   depends_on = [module.kube_dev_master_001]
# }
#
# ############################
# # Kube Prod Master VM Module
# ############################
#
# module "kube_prod_master_001" {
#   source = "./vm-config/kube-prod-master-001"
#
#   pm_node               = var.pm_node
#   vm_password           = var.vm_password
#   ssh_public_key        = var.ssh_public_key
#   dns_servers           = var.dns_servers
#   debian_cloud_image_id = proxmox_virtual_environment_download_file.debian_cloud_image.id
#   sdn_applier           = proxmox_virtual_environment_sdn_applier.sdn_applier
#
#   depends_on = [module.firewall_001]
# }
#
# ############################
# # Kube Prod Worker VM Module
# ############################
#
# module "kube_prod_worker_001" {
#   source = "./vm-config/kube-prod-worker-001"
#
#   pm_node               = var.pm_node
#   vm_password           = var.vm_password
#   ssh_public_key        = var.ssh_public_key
#   dns_servers           = var.dns_servers
#   debian_cloud_image_id = proxmox_virtual_environment_download_file.debian_cloud_image.id
#   sdn_applier           = proxmox_virtual_environment_sdn_applier.sdn_applier
#
#   depends_on = [module.kube_prod_master_001]
# }
#
# ############################
# # Management Prod VM Module
# ############################
#
# module "mgmt_prod_001" {
#   source = "./vm-config/mgmt-prod-001"
#
#   pm_node               = var.pm_node
#   vm_password           = var.vm_password
#   ssh_public_key        = var.ssh_public_key
#   dns_servers           = var.dns_servers
#   debian_cloud_image_id = proxmox_virtual_environment_download_file.debian_cloud_image.id
#   sdn_applier           = proxmox_virtual_environment_sdn_applier.sdn_applier
#
#   depends_on = [module.kube_prod_master_001]
# }
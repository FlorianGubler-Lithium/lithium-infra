############################
# VM Configuration from Files
############################

locals {
  # Load all VM configs from vm-config/<vm-name>/config.json
  vm_configs = {
    for config_dir in fileset("${path.module}/vm-config", "*") :
    config_dir => jsondecode(file("${path.module}/vm-config/${config_dir}/config.json"))
    if contains(["proxy-001", "firewall-001"], config_dir)
  }

  all_vms = local.vm_configs
}



variable "pm_api_token_secret" {
  type        = string
  sensitive   = true
  description = "Proxmox API token secret"
}

variable "vm_password" {
  type        = string
  sensitive   = true
  description = "Default password for VMs"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for VM access"
  sensitive   = true
}

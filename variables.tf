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

# Semaphore configuration
variable "semaphore_version" {
  type        = string
  description = "Semaphore version to install"
}

variable "semaphore_admin_password" {
  type        = string
  sensitive   = true
  description = "Semaphore admin user password"
}

variable "semaphore_db_password" {
  type        = string
  sensitive   = true
  description = "Semaphore database user password"
}

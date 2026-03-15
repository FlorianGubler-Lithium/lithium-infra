locals {
  # Proxmox API Endpoint and Node Configuration
  pm_api_url = "https://192.168.1.25:8006"
  pm_node = "prx-001"
  # Default VM Nameservers (DNS) Configuration
  vm_nameservers = ["8.8.8.8", "8.8.4.4"]
}
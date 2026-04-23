terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.98.1"
    }
  }
}

provider "proxmox" {
  endpoint = local.pm_api_url
  api_token = "terraform@pam!terraform-access=${var.pm_api_token_secret}"
  insecure = true

  # Note: ssh agent needs to have the proper keys loaded
  ssh {
    agent = true
    username = "root"
  }
}


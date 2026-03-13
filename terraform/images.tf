##########################
# Download Cloud Images to Proxmox Storage
##########################

resource "proxmox_virtual_environment_download_file" "debian_cloud_image" {
  node_name = var.pm_node
  datastore_id = "local"

  content_type = "import"
  url = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
  file_name = "debian-13-cloud.qcow2"
}


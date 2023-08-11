terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  alias           = "node1"
  pm_tls_insecure = true
  pm_api_url      = var.node1_url
  pm_user         = var.node_username
  pm_password     = var.node_password
}

provider "proxmox" {
  alias           = "node2"
  pm_tls_insecure = true
  pm_api_url      = var.node2_url
  pm_user         = var.node_username
  pm_password     = var.node_password
}

resource "proxmox_vm_qemu" "k3s-master1" {
  provider = proxmox.node1
  agent = 1
  clone = var.vm_name
  cores = 2
  cpu = "host"
  desc = "Debian 12.1, created with Packer, terraformed. k3s master"
  memory = 8192
  name = "k3s-master1"
  numa = true
  qemu_os = "l26"
  sockets = "1"
  tags = "k3s;linux"
  target_node = var.node1
  tablet = false
  vmid = 1100

  network {
    macaddr = "BA:AD:C0:FF:EE:00"
    model = "virtio"
    bridge = var.bridge
  }

  disk {
    type = "scsi"
    storage = var.storage_pool
    size = var.vm_size
    discard = "on"
  }
}

resource "proxmox_vm_qemu" "k3s-worker1" {
  provider = proxmox.node2
  agent = 1
  clone = var.vm_name
  cores = 2
  cpu = "host"
  desc = "Debian 12.1, created with Packer, terraformed. k3s worker"
  memory = 8192
  name = "k3s-worker1"
  numa = true
  qemu_os = "l26"
  sockets = "1"
  tags = "k3s;linux"
  target_node = var.node2
  vmid = 1101

  network {
    macaddr = "BA:AD:C0:FF:EE:01"
    model = "virtio"
    bridge = var.bridge
  }

  disk {
    type = "scsi"
    storage = var.storage_pool
    size = var.vm_size
    discard = "on"
  }
}

# resource "proxmox_vm_qemu" "k3s-worker" {
#   agent = 1
#   clone = var.vm_name
#   cores = 1
#   count = 2
#   cpu = "host"
#   desc = "Debian 12, created with Packer, terraformed. k3s worker${count.index + 1}"
#   memory = 4096
#   name = "k3s-worker${count.index + 1}"
#   numa = true
#   qemu_os = "l26"
#   sockets = "1"
#   tags = "k3s;linux"
#   target_node = var.node
#   vmid = 1100 + (count.index + 1)

#   network {
#     macaddr = "BA:AD:C0:FF:EE:0${count.index + 1}"
#     model = "virtio"
#     bridge = var.bridge
#   }

#   disk {
#     type = "scsi"
#     storage = var.storage_pool
#     size = "48G"
#     discard = "on"
#   }
# }
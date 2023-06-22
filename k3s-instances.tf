terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url = var.node_url
  pm_user = var.node_username
  pm_password = var.node_password
}

resource "proxmox_vm_qemu" "k3s-master" {
  agent = 1
  clone = var.vm_name
  cores = 2
  cpu = "host"
  desc = "Debian 12, created with Packer. k3s master"
  memory = 6144
  name = "k3s-master-tf"
  numa = true
  qemu_os = "l26"
  sockets = "1"
  tags = "k3s;linux"
  target_node = var.node
  vmid = 1100

  network {
    macaddr = "52:54:00:00:00:00"
    model = "virtio"
    bridge = var.bridge
  }

  disk {
    type = "virtio"
    storage = var.storage_pool
    size = "48G"
    discard = "on"
  }
}

resource "proxmox_vm_qemu" "k3s-worker" {
  agent = 1
  clone = var.vm_name
  cores = 1
  count = 2
  cpu = "host"
  desc = "Debian 12, created with Packer. k3s worker${count.index + 1}"
  memory = 4096
  name = "k3s-worker${count.index + 1}-tf"
  numa = true
  qemu_os = "l26"
  sockets = "1"
  tags = "k3s;linux"
  target_node = var.node
  vmid = 1100 + (count.index + 1)

  network {
    macaddr = "52:54:00:00:00:0${count.index + 1}"
    model = "virtio"
    bridge = var.bridge
  }

  disk {
    type = "virtio"
    storage = var.storage_pool
    size = "48G"
    discard = "on"
  }
}
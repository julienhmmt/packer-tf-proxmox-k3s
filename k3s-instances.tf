terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url = var.pm_api_url
  pm_user = var.pm_user
  pm_password = var.pm_password
}

resource "proxmox_vm_qemu" "k3s-master" {
  agent = 1
  clone = "debian12-packer"
  cores = 2
  cpu = "host"
  desc = "Debian 12, created with Packer. k3s master"
  memory = 6144
  name = "k3s-master-tf"
  numa = true
  qemu_os = "l26"
  sockets = "1"
  tags = "k3s;linux"
  target_node = "proxmou1"
  vmid = 1100

  network {
    model = "virtio"
    bridge = "vmbr1"
  }

  disk {
    type = "virtio"
    storage = "crucial"
    size = "48G"
    discard = "on"
  }
}

resource "proxmox_vm_qemu" "k3s-worker" {
  agent = 1
  clone = "debian12-packer"
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
  target_node = "proxmou1"
  vmid = 1100 + (count.index + 1)

  network {
    model = "virtio"
    bridge = "vmbr1"
  }

  disk {
    type = "virtio"
    storage = "crucial"
    size = "48G"
    discard = "on"
  }
}
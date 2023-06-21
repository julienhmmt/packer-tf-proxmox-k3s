packer {
  required_plugins {
    proxmox-iso = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "debian" {
  boot_command = ["<esc><wait>", "auto <wait>", "console-keymaps-at/keymap=fr <wait>", "console-setup/ask_detect=false <wait>", "debconf/frontend=noninteractive <wait>", "debian-installer=fr_FR <wait>", "fb=false <wait>", "install <wait>", "packer_host={{ .HTTPIP }} <wait>", "packer_port={{ .HTTPPort }} <wait>", "kbd-chooser/method=fr <wait>", "keyboard-configuration/xkb-keymap=fr <wait>", "locale=fr_FR <wait>", "netcfg/get_hostname=debian12-packer <wait>", "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>", "<enter><wait>"]
  boot_wait    = "10s"
  cores        = "1"

  disks {
    disk_size    = "8G"
    format       = "${var.disk_format}"
    storage_pool = "${var.storage_pool}" # change it with the name of your storage pool
    type         = "virtio"
  }

  http_directory           = "http"
  insecure_skip_tls_verify = true
  iso_checksum             = "file:https://cdimage.debian.org/debian-cd/12.0.0/amd64/iso-cd/SHA256SUMS"
  iso_file                 = "local:iso/debian-12.0.0-amd64-netinst.iso" # change it with the name of your storage pool where the file is 
  memory                   = 1024

  network_adapters {
    bridge = "${var.bridge}"
    model  = "virtio"
  }

  node                 = "${var.node}"
  os                   = "l26"
  password             = "${var.node_password}"
  proxmox_url          = "https://${var.node_url}/api2/json" # change it
  qemu_agent           = "true"
  ssh_password         = "${var.sudo_password}"
  ssh_timeout          = "10m"
  ssh_username         = "${var.ssh_username}"
  template_description = "Debian 12, created with Packer"
  unmount_iso          = true
  username             = "${var.node_username}" # change it
  vm_id                = "${var.vm_id}"
  vm_name              = "${var.vm_name}"
}

build {
  sources = ["source.proxmox-iso.debian" ]

  provisioner "file" {
    source      = "post-install.sh"
    destination = "/tmp/post-install.sh"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/post-install.sh",
      "/tmp/post-install.sh"
    ]
  }

  post-processor "manifest" {
    output = "debian.json"
  }
}
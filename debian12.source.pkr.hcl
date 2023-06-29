source "proxmox-iso" "debian12" {
  proxmox_url              = var.node_url
  username                 = var.node_username
  password                 = var.node_password
  insecure_skip_tls_verify = true
  node                     = var.node

  vm_name                 = var.vm_name
  template_description    = "Debian 12 Booksworm Packer Template -- Created: ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
  vm_id                   = var.vm_id
  os                      = "l26"
  cpu_type                = var.type_cpu
  sockets                 = var.nb_cpu
  cores                   = var.nb_core
  memory                  = var.nb_ram
  machine                 = "q35"
  bios                    = "seabios"
  scsi_controller         = "virtio-scsi-pci"
  qemu_agent              = true

  network_adapters {
    bridge   = var.bridge
    firewall = true
    model    = "virtio"
  }

  disks {
    disk_size         = var.disk_size
    format            = var.disk_format
    storage_pool      = var.storage_pool
    type              = "scsi"
  }
  efi_config {
    efi_storage_pool  = var.storage_pool
    efi_type          = "4m"
    pre_enrolled_keys = true
  }

  iso_file       = "local:iso/debian-12.0.0-amd64-netinst.iso" # change it with the name of your storage pool where the file is 
  iso_checksum   = "file:https://cdimage.debian.org/debian-cd/12.0.0/amd64/iso-cd/SHA256SUMS"
  unmount_iso    = true

  http_directory = "http"
  http_port_min  = 8100
  http_port_max  = 8100
  boot_wait      = "10s"
  boot_command   = ["<esc><wait>auto console-keymaps-at/keymap=fr console-setup/ask_detect=false debconf/frontend=noninteractive fb=false url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]

  ssh_username = var.ssh_username
  ssh_password = var.sudo_password
  ssh_timeout  = "20m"
}
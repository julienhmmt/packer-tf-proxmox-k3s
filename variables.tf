variable "bridge" {
  type    =  string
  default = "vmbr0"
}

variable "disk_format" {
  type    =  string
  default = "qcow2"
}

variable "node1" {
  type    =  string
  default = "srv1"
}

variable "node2" {
  type    =  string
  default = "srv2"
}

variable "node_password" {
  type    =  string
  default = "password"
}

variable "node1_url" {
  type    =  string
  default = "https://192.168.1.10:8006/api2/json" # can be a dns name with the port (e.q. "srv1:8006")
}

variable "node2_url" {
  type    =  string
  default = "https://192.168.1.11:8006/api2/json" # can be a dns name with the port (e.q. "srv2:8006")
}

variable "node_username" {
  type    =  string
  default = "root@pam" # prefer use a specific use for packer on pve realm
}

variable "ssh_username" {
  type    =  string
  default = "user"
}

variable "storage_pool" {
  type    =  string
  default = "datastore"
}

variable "sudo_password" {
  type    =  string
  default = "password"
  sensitive = true
}

variable "vm_id" {
  type    =  number
  default = 99999
}

variable "vm_name" {
  type    =  string
  default = "deb12-pcker"
}

variable "vm_size" {
  type    =  string
  default = "24G"
}
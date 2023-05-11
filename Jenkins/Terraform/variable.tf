variable "resource_group" {
  type    = string
  default = "Jenkins"
}

variable "location" {
  type    = string
  default = "eastus2"

}

variable "virtual_network" {
  type        = string
  default     = "VirtualNetwork-01"
  description = "description"
}
variable "SubnetName" {
  type        = string
  default     = "SubnetA"
  description = "description"
}
variable "NetworkInterface" {
  type        = string
  default     = "Network"
  description = "description"
}
variable "StorageAccount" {
  type        = string
  default     = "storage-01"
  description = "description"
}

variable "StorageContainer" {
  type        = string
  default     = "container01"
  description = "description"
}

variable "VM" {
  type        = string
  default     = "Jenkins"
  description = "description"
}

variable "vm_username" {
  type        = string
  description = "username of vm admin user"
}

variable "vm_password" {
  type        = string
  description = "password of vm admin user"
}

variable "SshPath" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "description"
}

variable "PathStoreIp" {
  type        = string
  default     = "ip.txt"
  description = "description"
}



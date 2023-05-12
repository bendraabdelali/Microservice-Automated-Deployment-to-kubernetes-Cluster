variable "resource_group" {
  type    = string
  default = "kubernetes"
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "cluster_name" {
  type        = string
  default     = "AKS-01"
  description = "the name of the kubernetes cluster"

}

variable "kubernetes_version" {
  type = string

}

variable "worker" {
  type    = number
  default = 1
}

variable "containerRegistryName" {
  type    = string
  default = "container67Registry199723"
}




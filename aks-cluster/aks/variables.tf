variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "node_pool_name" {
  type = string
  default = "default"
}

variable "node_pool_vm_size" {
  type = string
}

variable "node_pool_vm_count" {
  type = number
  default = 3
}
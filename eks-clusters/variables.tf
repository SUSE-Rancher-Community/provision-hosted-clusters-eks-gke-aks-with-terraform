variable "profile" {
  description = "AWS profile"
  default = "your-aws-profile"
  type        = string
}

variable "region" {
  description = "AWS region to deploy to"
  default = "eu-west-1"
  type        = string
}

variable "cluster_name1" {
  description = "EKS cluster name"
  default = "rancher"
  type = string
}

variable "cluster_name2" {
  description = "EKS cluster name"
  default = "alpha"
  type = string
}
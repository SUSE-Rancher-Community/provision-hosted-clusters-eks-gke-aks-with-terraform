provider "aws" {
  region = var.region
  profile = var.profile
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "unique-name" # This should match the unique name of the bucket you create as specified in the README steps.
    key = "rancher-managed-eks-clusters/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}
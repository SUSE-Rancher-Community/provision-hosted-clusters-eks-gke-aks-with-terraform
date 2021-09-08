provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

  backend "s3" {
    bucket = "unique-name" # This should match the unique name of the bucket you create as specified in the README steps.
    key = "rancher-managed-aks-cluster/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}
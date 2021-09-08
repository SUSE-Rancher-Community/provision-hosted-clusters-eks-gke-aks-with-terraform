provider "google" {
  project     = "your-project-id"
  region      = "europe-west1"
  zone        = "europe-west1-a"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "unique-name" # This should match the unique name of the bucket you create as specified in the README steps. 
    key = "rancher-managed-gke-cluster/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}

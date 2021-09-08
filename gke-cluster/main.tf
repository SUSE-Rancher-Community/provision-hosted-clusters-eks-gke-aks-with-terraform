# GKE Cluster
module "gke_cluster" {
  source = "./gke"
  account_id = "your-account-id" # same as project id
  google_service_account_display_name = "Compute Engine default service account"
  cluster_name = "beta"
  node_pool_name = "beta-node-pool"
  node_config_machine_type = "e2-medium"
  location = "europe-west1"
}
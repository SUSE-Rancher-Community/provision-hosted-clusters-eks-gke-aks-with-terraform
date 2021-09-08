# AKS Cluster
module "aks_cluster" {
  source = "./aks"
  location = "West Europe"
  cluster_name = "charlie"
  resource_group_name = "charlie-resource-group"
  node_pool_name = "charlie"
  node_pool_vm_size = "Standard_D2_v2"
  node_pool_vm_count = 2
}
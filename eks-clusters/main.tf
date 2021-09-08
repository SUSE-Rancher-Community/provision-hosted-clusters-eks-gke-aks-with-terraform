# VPCs for EKS Clusters
module "vpc_for_eks1" {
  source = "./vpc"
  eks_cluster_name = var.cluster_name1
  vpc_tag_name = "${var.cluster_name1}-vpc"
  region = var.region
}

module "vpc_for_eks2" {
  source = "./vpc"
  eks_cluster_name = var.cluster_name2
  vpc_tag_name = "${var.cluster_name2}-vpc"
  region = var.region
}

# EKS Clusters 
module "eks_cluster_and_worker_nodes1" {
  source = "./eks"
  # Cluster
  vpc_id = module.vpc_for_eks1.vpc_id
  cluster_sg_name = "${var.cluster_name1}-cluster-sg"
  nodes_sg_name = "${var.cluster_name1}-node-sg"
  eks_cluster_name = var.cluster_name1
  eks_cluster_subnet_ids = flatten([module.vpc_for_eks1.public_subnet_ids, module.vpc_for_eks1.private_subnet_ids])
  # Node group configuration (including autoscaling configurations)
  pvt_desired_size = 2
  pvt_max_size = 8
  pvt_min_size = 2
  pblc_desired_size = 0
  pblc_max_size = 1
  pblc_min_size = 0
  endpoint_private_access = true
  endpoint_public_access = true
  node_group_name = "${var.cluster_name1}-node-group"
  private_subnet_ids = module.vpc_for_eks1.private_subnet_ids
  public_subnet_ids = module.vpc_for_eks1.public_subnet_ids
}

module "eks_cluster_and_worker_nodes2" {
  source = "./eks"
  # Cluster
  vpc_id = module.vpc_for_eks2.vpc_id
  cluster_sg_name = "${var.cluster_name2}-cluster-sg"
  nodes_sg_name = "${var.cluster_name2}-node-sg"
  eks_cluster_name = var.cluster_name2
  eks_cluster_subnet_ids = flatten([module.vpc_for_eks2.public_subnet_ids, module.vpc_for_eks2.private_subnet_ids])
  # Node group configuration (including autoscaling configurations)
  pvt_desired_size = 2
  pvt_max_size = 8
  pvt_min_size = 2
  pblc_desired_size = 0
  pblc_max_size = 1
  pblc_min_size = 0
  endpoint_private_access = true
  endpoint_public_access = true
  node_group_name = "${var.cluster_name2}-node-group"
  private_subnet_ids = module.vpc_for_eks2.private_subnet_ids
  public_subnet_ids = module.vpc_for_eks2.public_subnet_ids
}
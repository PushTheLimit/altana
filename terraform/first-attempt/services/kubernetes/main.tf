# Set up the VPC
module "kubernetes_vpc" {
  source = "../../modules/vpc"

  env         = var.env
  application = var.application
  cidr_block  = var.vpc_cidr
}

# Set up the internet gateway
module "kubernetes_internet_gateway" {
  source = "../../modules/internet_gateway"

  env         = var.env
  application = var.application
  vpc_id      = module.kubernetes_vpc.selected_vpc_id

  depends_on = [module.kubernetes_vpc]
}

# Set up the NAT gateway
module "kubernetes_nat_gateway" {
  source = "../../modules/nat_gateway"

  env                   = var.env
  application           = var.application
  vpc_id                = module.kubernetes_vpc.selected_vpc_id
  internet_gateway_name = module.kubernetes_internet_gateway.selected_name
  nat_gateway_config    = var.nat_gateway_config

  depends_on = [module.kubernetes_vpc, module.kubernetes_internet_gateway]
}

# Set up the EKS cluster
module "kubernetes_eks_cluster" {
  source = "../../modules/eks_cluster"

  env                     = var.env
  application             = var.application
  subnet_ids              = module.kubernetes_nat_gateway.subnet_ids
  endpoint_private_access = var.eks_cluster_config.endpoint_private_access
  endpoint_public_access  = var.eks_cluster_config.endpoint_public_access
  kubernetes_version      = var.eks_cluster_config.kubernetes_version

  depends_on = [module.kubernetes_vpc, module.kubernetes_internet_gateway, module.kubernetes_nat_gateway]
}

# Add node group to the EKS cluster
module "kubernetes_eks_node_group" {
  source = "../../modules/eks_node_group"

  env                   = var.env
  application           = var.application
  aws_eks_cluster_name  = module.kubernetes_eks_cluster.selected_name
  subnet_ids            = module.kubernetes_nat_gateway.subnet_ids
  eks_node_group_config = var.eks_node_group_config
}

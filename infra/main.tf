
locals {
  eks_cluster_name = "ogata-infra"
}

module "vpc" {
  source           = "./modules/vpc"
  vpc_name         = "ogata"
  vpc_cidr         = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # 3 subnets because there are 3 azs in us-east-2
  public_subnets   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  eks_cluster_name = local.eks_cluster_name
}

module "eks_cluster" {
  source          = "./modules/eks_cluster"
  cluster_name    = local.eks_cluster_name
  vpc_id          = module.vpc.vpc_info.vpc_id
  private_subnets = module.vpc.subnet_info.private_subnets
  #k8s_version     = "1.21"
  vpc_cidr        = module.vpc.vpc_info.cidr
}
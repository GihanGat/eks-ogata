module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = var.cluster_name
  # cluster_version = var.k8s_version

  cluster_endpoint_public_access = true
  create_aws_auth_configmap      = true
  manage_aws_auth_configmap      = true

  cluster_addons = {
    coredns = {}
    kube-proxy = {}
    vpc-cni = {}
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  # self_managed_node_group_defaults = {
  #   ami_id = "ami-0bf61ea17cec89b3a"
  # }

  self_managed_node_groups = {
    ogata-1 = {
      name                          = "ogata-1"
      max_size                      = 3
      desired_size                  = 3
      min_size = 3
      instance_type                 = "t3.xlarge"
      additional_security_group_ids = [aws_security_group.kube_worker_mgmt.id]
      subnets                       = var.private_subnets
    }
  }

  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "tls_certificate" "cluster" {
  url = module.eks.cluster_oidc_issuer_url
}
provider "aws" {
  region = "ca-central-1"
}

# provider "kubectl" {
#   host                   = module.eks_cluster.kubernetes_config.host
#   cluster_ca_certificate = module.eks_cluster.kubernetes_config.ca_cert
#   token                  = module.eks_cluster.kubernetes_config.token
# }

# provider "kubernetes" {
#   host                   = module.eks_cluster.kubernetes_config.host
#   cluster_ca_certificate = module.eks_cluster.kubernetes_config.ca_cert
#   token                  = module.eks_cluster.kubernetes_config.token
# }

# provider "helm" {
#   kubernetes {
#     host                   = module.eks_cluster.kubernetes_config.host
#     cluster_ca_certificate = module.eks_cluster.kubernetes_config.ca_cert
#     token                  = module.eks_cluster.kubernetes_config.token
#   }
# }

terraform {
  backend "s3" {
    bucket = "terraform-ogata-com"
    key    = "infra.tfstate"
    region = "ca-central-1"
  }
}
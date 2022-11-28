output "kubernetes_config" {
  value = {
    host              = data.aws_eks_cluster.cluster.endpoint
    ca_cert           = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token             = data.aws_eks_cluster_auth.cluster.token
    oidc_issuer_url   = module.eks.cluster_oidc_issuer_url
    oidc_provider_arn = module.eks.oidc_provider_arn
  }
}
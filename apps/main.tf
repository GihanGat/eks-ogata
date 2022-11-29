
locals {
  eks_cluster_name = "ogata-infra"
  aws_region       = "ca-central-1"
}

module "alb_ingress_controller" {
  source            = "./modules/alb-ingress-controller"
  vpc_id            = data.terraform_remote_state.ogata_infra.outputs.infra.vpc_id
  region            = local.aws_region
  oidc_provider_arn = data.terraform_remote_state.ogata_infra.outputs.kubernetes_config.oidc_provider_arn
  oidc_issuer_url   = data.terraform_remote_state.ogata_infra.outputs.kubernetes_config.oidc_issuer_url
  cluster_name      = local.eks_cluster_name
}

module "grafana-prometheus" {
  source               = "./modules/grafana-prometheus"
  #name                 = "grafana-prometheus"
  #kubernetes_namespace = "grafana-prometheus"
  name                 = "grafana"
  kubernetes_namespace = "loki-stack"
  chart_version        = "2.8.7"
}

module "spring-petclinic" {
  source               = "./modules/spring-petclinic"
  name                 = "spring-petclinic"
  kubernetes_namespace = "spring-petclinic"
  chart_version        = "0.2.0"
}

module "metrics-server" {
  source               = "./modules/metrics-server"
  #name                 = "metrics-server"
  kubernetes_namespace = "metrics-server"
  #chart_version        = "0.2.0"
}
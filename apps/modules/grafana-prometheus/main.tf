resource "kubernetes_namespace" "grafana_prometheus" {
  metadata {
    name = var.kubernetes_namespace
  }
}


resource "helm_release" "grafana_prometheus" {
  #name       = "grafana-prometheus"
  name       = "loki-stack"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = var.kubernetes_namespace
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]
}


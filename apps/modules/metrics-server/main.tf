# resource "aws_ecr_repository" "ogata" {
#   name = "ogata"
# }

resource "kubernetes_namespace" "metrics-server" {
  metadata {
    name = var.kubernetes_namespace
  }
}

resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  namespace  = var.kubernetes_namespace
  # version    = var.chart_version
}


# resource "kubernetes_deployment" "myapp" {
#   metadata {
#     name = "microservice-deployment"
#     labels = {
#       app  = "myapp"
#     }
#   }
# spec {
#     replicas = 2
# selector {
#       match_labels = {
#         app  = "myapp"
#       }
#     }
# template {
#       metadata {
#         labels = {
#           app  = "myapp"
#         }
#       }
# spec {
#         container {
#           image = "935501273130.dkr.ecr.ca-central-1.amazonaws.com/ogata:latest"
#           name  = "myapp-container"
#           port {
#             container_port = 8080
#          }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "java" {
#   depends_on = [kubernetes_deployment.java]
#   metadata {
#     name = "java-microservice-service"
#   }
#   spec {
#     selector = {
#       app = "java-microservice"
#     }
#     port {
#       port        = 80
#       target_port = 8080
#     }
# type = "LoadBalancer"
# }

# }
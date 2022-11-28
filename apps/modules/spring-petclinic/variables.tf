
variable "kubernetes_namespace" {
  type        = string
  description = "Kubernetes namespace for my-app"
}

variable "name" {
  type        = string
  description = "Name for the My App service"
}

variable "chart_version" {
  type        = string
  description = "Helm chart version"
}
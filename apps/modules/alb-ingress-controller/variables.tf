variable "vpc_id" {
  type = string
}

variable "region" {
  type        = string
  description = "AWS region"
}

# variable "kubernetes_config" {
#   type = object({
#     host            = string
#     ca_cert         = string
#     oidc_issuer_url = string

#   })
#   description = "Configuration for kubernetes provider"
# }

variable "cluster_name" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "oidc_issuer_url" {
  type = string
}
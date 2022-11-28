variable "vpc_id" {
  type        = string
  description = "ID of VPC to create EKS cluster in"
}

variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}

# variable "k8s_version" {
#   type        = string
#   description = "Kubernetes version of the EKS cluster"
# }

variable "private_subnets" {
  type        = list(string)
  description = "The list of private subnet ids for the k8s workers"
}

variable "vpc_cidr" {
  type = string
}
variable "vpc_name" {
  type        = string
  description = "Name of the vpc"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for the public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for the private subnets"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR for the vpc"
}

variable "eks_cluster_name" {
  type        = string
  default     = ""
  description = "Name of the eks cluster"
}


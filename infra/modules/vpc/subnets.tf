data "aws_availability_zones" "available" {}

locals {
  azs     = data.aws_availability_zones.available.names
  num_azs = length(local.azs)
}

resource "aws_subnet" "public" {
  count                   = local.num_azs
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = local.azs[count.index]
  tags = {
    Name                                            = "${var.vpc_name} public #${count.index}"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }
}

resource "aws_subnet" "private" {
  count                   = local.num_azs
  vpc_id                  = aws_vpc.infra.id
  cidr_block              = var.private_subnets[count.index]
  map_public_ip_on_launch = false
  availability_zone       = local.azs[count.index]
  tags = {
    Name                                            = "${var.vpc_name} private #${count.index}"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}
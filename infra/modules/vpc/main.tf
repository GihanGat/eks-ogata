resource "aws_vpc" "infra" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = var.vpc_name
  }
}

resource "aws_internet_gateway" "infra" {
  vpc_id = aws_vpc.infra.id
  tags = {
    Name                                            = "${var.vpc_name}"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

resource "aws_eip" "infra_natgw_eip" {}

resource "aws_nat_gateway" "infra" {
  allocation_id = aws_eip.infra_natgw_eip.id
  subnet_id     = aws_subnet.public[0].id
}

resource "aws_route_table" "infra_private" {
  vpc_id = aws_vpc.infra.id
  tags = {
    Name = "${var.vpc_name} private"
  }
}

resource "aws_route_table_association" "infra_private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.infra_private.id
}

resource "aws_route" "infra_public_default" {
  route_table_id         = aws_vpc.infra.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.infra.id
}

resource "aws_route" "infra_private_default" {
  route_table_id         = aws_route_table.infra_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.infra.id
}
output "vpc_info" {
  value = {
    vpc_id = aws_vpc.infra.id
    cidr   = aws_vpc.infra.cidr_block
  }
}

output "subnet_info" {
  value = {
    public_subnets  = aws_subnet.public[*].id
    private_subnets = aws_subnet.private[*].id
  }
}
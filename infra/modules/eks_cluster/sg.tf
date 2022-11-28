resource "aws_security_group" "kube_worker_mgmt" {
  name   = "${var.cluster_name} inbound tcp/22 from ${var.vpc_cidr}"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [var.vpc_cidr]
  }
}

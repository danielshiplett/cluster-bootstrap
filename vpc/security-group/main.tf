resource "aws_security_group" "jumpbox-sg" {
  name        = "${var.clusterid}-jumpbox-sg"
  description = "Security Group for Jumpbox Instance"
  vpc_id      = var.vpc

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_ingress_cidr]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = map("Name", "${var.clusterid}-jumpbox-sg", "project", "${var.project}", "team", "${var.team}", "kubernetes.io/cluster/${var.clusterid}", "owned")
}

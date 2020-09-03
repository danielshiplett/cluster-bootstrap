data "aws_availability_zones" "available-azs" {}

resource "aws_subnet" "private1" {
    vpc_id = var.vpc
    availability_zone = data.aws_availability_zones.available-azs.names[var.az_index]
    cidr_block = var.private_cidr_subnet

    tags = {
        Name = "${var.clusterid}-${var.name}"
        project = var.project
        team = var.team
    }
}
resource "aws_route_table" "opc-nat-rt-1" {
  vpc_id = var.vpc

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.nat_gw_ids[0]
  }

  tags = {
    Name = "${var.clusterid}-${var.name}-rt"
    project = var.project
    team = var.team
  }
}
resource "aws_route_table_association" "priv-sn-1-rt-assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.opc-nat-rt-1.id
}

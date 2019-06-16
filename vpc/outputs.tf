output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "jumpbox_sg" {
  value = "${module.security-group.jumpbox_sg}"
}

output "jumpbox_subnet" {
  value = "${module.jumpbox-subnet.id}"
}

output "management_subnet" {
  value = "${module.management-subnet.id}"
}

output "core_subnet" {
  value = "${module.core-subnet.id}"
}

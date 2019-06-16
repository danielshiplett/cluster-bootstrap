data "aws_availability_zones" "available-azs" {}

############################# VPC ####################################
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name    = "${var.clusterid}-vpc"
    project = "${var.project}"
    team    = "${var.team}"
  }
}

############################# DHCP ####################################
resource "aws_vpc_dhcp_options" "vpc-dhcp" {
  domain_name         = "${var.region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name    = "${var.clusterid}-vpc-dhcp"
    project = "${var.project}"
    team    = "${var.team}"
  }
}

resource "aws_vpc_dhcp_options_association" "dhcp-association" {
  vpc_id          = "${aws_vpc.vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.vpc-dhcp.id}"
}

########################### Security Groups ############################
module "security-group" {
  source           = "./security-group"
  clusterid        = "${var.clusterid}"
  vpc              = "${aws_vpc.vpc.id}"
  vpc_cidr_block   = "${var.vpc_cidr_block}"
  clusterid        = "${var.clusterid}"
  team             = "${var.team}"
  project          = "${var.project}"
  nat_eip          = "${aws_nat_gateway.gw-1.public_ip}"
  ssh_ingress_cidr = "${var.ssh_ingress_cidr}"
}

############################# Public ####################################
module "jumpbox-subnet" {
  source             = "./public"
  vpc                = "${aws_vpc.vpc.id}"
  igw                = "${aws_internet_gateway.igw.id}"
  az_index           = "${var.az_index}"
  public_cidr_subnet = "${var.jumpbox_subnet}"
  name               = "jumpbox-subnet"
  clusterid          = "${var.clusterid}"
  team               = "${var.team}"
  project            = "${var.project}"
}

module "management-subnet" {
  source             = "./public"
  vpc                = "${aws_vpc.vpc.id}"
  igw                = "${aws_internet_gateway.igw.id}"
  az_index           = "${var.az_index}"
  public_cidr_subnet = "${var.management_subnet}"
  name               = "management-subnet"
  clusterid          = "${var.clusterid}"
  team               = "${var.team}"
  project            = "${var.project}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name    = "${var.clusterid}-igw"
    project = "${var.project}"
    team    = "${var.team}"
  }
}

############################# Private ####################################
module "core-subnet" {
  source              = "./private"
  vpc                 = "${aws_vpc.vpc.id}"
  az_index            = "${var.az_index}"
  private_cidr_subnet = "${var.core_subnet}"
  nat_gw_ids          = ["${aws_nat_gateway.gw-1.id}"]
  name                = "core-subnet"
  clusterid           = "${var.clusterid}"
  team                = "${var.team}"
  project             = "${var.project}"
}

resource "aws_eip" "gw-1-eip" {
  vpc = "true"

  tags {
    Name    = "${var.clusterid}-eip-${data.aws_availability_zones.available-azs.names[var.az_index]}"
    project = "${var.project}"
    team    = "${var.team}"
  }
}

resource "aws_nat_gateway" "gw-1" {
  allocation_id = "${aws_eip.gw-1-eip.id}"
  subnet_id     = "${module.management-subnet.id}"

  tags {
    Name    = "${var.clusterid}-nat-${data.aws_availability_zones.available-azs.names[var.az_index]}"
    project = "${var.project}"
    team    = "${var.team}"
  }
}

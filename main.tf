#
# Creates a VPC dedicated to the use of this cluster.
#
module "vpc" {
  source            = "./vpc"
  clusterid         = local.clusterid
  team              = var.team
  project           = var.project
  region            = var.region
  az_index          = var.az_index
  vpc_cidr_block    = var.vpc_cidr_block
  jumpbox_subnet    = var.jumpbox_subnet
  management_subnet = var.management_subnet
  core_subnet       = var.core_subnet
  ssh_ingress_cidr  = var.ssh_ingress_cidr
}

#
# Install a KeyPair that is generated for this cluster's default uesr.
#
resource "aws_key_pair" "keypair" {
  key_name   = "${local.clusterid}.${var.dns_domain}"
  public_key = file("${var.bootstrap_ssh_key}")
}

#
# Create a Jumpbox in the Jumpbox subnet (public) and associate a public IP with
# the instance. It will be our one and only SSH ingress into the cluster.  Its
# security group has a restricted ingress IP CIDR that should limit it to very
# few source IPs.
#
resource "aws_instance" "jumpbox" {
  ami                         = var.rhel_ami_id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.keypair.key_name
  vpc_security_group_ids      = ["${module.vpc.jumpbox_sg}"]
  subnet_id                   = module.vpc.jumpbox_subnet
  associate_public_ip_address = "true"

  root_block_device {
    volume_type = "gp2"
    volume_size = "128"
  }

  tags        = map("Name", "${local.clusterid}-jumpbox-00", "project", "${var.project}", "team", "${var.team}", "kubernetes.io/cluster/${local.clusterid}", "owned", "Schedule", "${var.schedule}")
  volume_tags = map("Name", "${local.clusterid}-jumpbox-00-RootVolume", "project", "${var.project}", "team", "${var.team}", "kubernetes.io/cluster/${local.clusterid}", "owned")

  # do all the VPC stuff before doing this jumpbox stuff
  depends_on = [module.vpc]
}

#
# This resource type (aws_eip) allocates and associates an elastic IP to an EC2 instance
#
resource "aws_eip" "jumpbox-eip" {
  vpc = "true"

  tags = {
    Name    = "${local.clusterid}-eip-jumpbox"
    project = var.project
    team    = var.team
  }

  depends_on = [aws_instance.jumpbox]
}

#
# Associates an Elastic IP address with an Amazon EC2 Instance.
#
resource "aws_eip_association" "jumpbox-assoc" {
  instance_id   = aws_instance.jumpbox.id
  allocation_id = aws_eip.jumpbox-eip.id

  depends_on = [aws_eip.jumpbox-eip]
}

#
# Wait until the jumpbox is accessible via SSH and cloud-init is complete.
#
resource "null_resource" "wait-jumpbox" {
  connection {
    host  = aws_eip.jumpbox-eip.public_ip
    type  = "ssh"
    user  = "centos"
    agent = "true"
  }

  provisioner "remote-exec" {
    inline = ["cloud-init status --wait"]
  }

  depends_on = [aws_eip_association.jumpbox-assoc]
}

#
# Provision the Jumpbox.  This will setup local administrators, install Ansible, clone
# an Ansible project, and setup an inventory.
#
# At this early point, all of this has to run local.  Additionally, we have no
# DNS, so we must use the public IP to reach the instance.  The first playbook is
# the early bootstrap playbook that needs to be told enough to login to get the
# initial set of administrators installed on the host.  After that, the normal
# site can be run on it.
#
resource "null_resource" "provision-jumpbox" {
  provisioner "local-exec" {
    command = <<EOC
  sleep 10;
  ansible-playbook -i ansible/inventory -e 'ansible_host=${aws_eip.jumpbox-eip.public_ip} bootstrap_host=jumpbox-00 bootstrap_user=centos bootstrap_keyfile=${var.bootstrap_ssh_key}' --limit jumpbox-00 ansible/bootstrap.yml;
  ansible-playbook -i ansible/inventory -e 'ansible_host=${aws_eip.jumpbox-eip.public_ip}' --limit jumpbox-00 ansible/site.yml
EOC
  }

  depends_on = [null_resource.wait-jumpbox]
}

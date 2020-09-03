variable "clusterid" {
  type        = string
  description = "name for cluster"
}

variable "team" {
  type        = string
  description = "Value to use for the 'team' tag added to aws resources"
}

variable "project" {
  type        = string
  description = "Value to use for the 'project' tag added to aws resources"
}

variable "vpc" {
  type        = string
  description = "id for the VPC"
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr to be used by vpc"
}

variable "nat_eip" {
  type        = string
  description = "Elastic IP of the NAT Gateway"
}

variable "ssh_ingress_cidr" {
  type        = string
  description = "CIDR block that is allowed to ingress via SSH to the jumpox."
}

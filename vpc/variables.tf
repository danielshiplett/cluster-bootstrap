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

variable "region" {
  type        = string
  description = "AWS region cluster is being deployed to"
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr to be used by vpc"
}

variable "jumpbox_subnet" {
  type        = string
  description = "Subnet for jumpbox instance"
}

variable "management_subnet" {
  type        = string
  description = "Subnet for ELBs, NAT, etc."
}

variable "core_subnet" {
  type        = string
  description = "Subnet for core instances (keycloak, gluster, hadoop, etc)"
}

variable "az_index" {
  type        = string
  description = "Available AZ's are stored in a list. The AZ within that list to deploy resources in is determined by this index. Note - the actual index used will be az_index % list_size"
  default     = "0"
}

variable "ssh_ingress_cidr" {
  type        = string
  description = "CIDR block that is allowed to ingress via SSH to the jumpox."
}

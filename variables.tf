variable "cluster_prefix" {
  type        = "string"
  description = "prefix for cluster"
}

variable "environment" {
  type        = "string"
  description = "type of environment (dev, test, prod, etc). Appended to cluster_prefix to form a clusterid"
  default     = "prod"
}

variable "team" {
  type        = "string"
  description = "Value to use for the 'team' tag added to aws resources"
}

variable "project" {
  type        = "string"
  description = "Value to use for the 'project' tag added to aws resources"
}

variable "schedule" {
  type        = "string"
  description = "Value to use for the 'Schedule' tag added to aws resources"
}

variable "dns_domain" {
  type        = "string"
  description = "domain name to be used for cluster"
}

variable "dns_subdomain" {
  type        = "string"
  description = "subdomain to be used when setting up the bind server"
}

variable "bootstrap_ssh_key" {
  type        = "string"
  description = "The location of the bootstrap SSH key that will be injected into new hosts.  This will create an AWS KeyPair from the keyfile."
}

variable "ssh_ingress_cidr" {
  type        = "string"
  description = "CIDR block that is allowed to ingress via SSH to the jumpox."
}

variable "sdn_cidr_block" {
  type        = "string"
  description = "cidr range that kubernetes will use for its SDN. IPs from this range will be assigned to pods and services. Cannot overlap with vpc cidr"
  default     = "10.128.0.0/14"
}

variable "region" {
  type        = "string"
  description = "region to deploy infrastructure to (ex: us-east-1)"
}

variable "profile" {
  type        = "string"
  description = "the AWS profile to use for access. Should correspond to a profile in your ~/.aws/credentials file"
}

variable "az_index" {
  type        = "string"
  description = "Available AZ's are stored in a list. The AZ within that list to deploy resources in is determined by this index. Note - the actual index used will be az_index % list_size"
  default     = "0"
}

variable "vpc_cidr_block" {
  type        = "string"
  description = "cidr to be used by vpc"
}

variable "jumpbox_subnet" {
  type        = "string"
  description = "Subnet for jumpbox instance"
}

variable "management_subnet" {
  type        = "string"
  description = "Subnet for ELBs, NAT, etc."
}

variable "core_subnet" {
  type        = "string"
  description = "Subnet for core application instances (gluster, keycloak, etc)"
}

# TODO: Rename
variable "rhel_ami_id" {
  type        = "string"
  description = "ID of the rhel ami to use for kubernetes deployment"
}

variable "ec2_user_name" {
  type        = "string"
  description = "The username to use when logging into EC2 Instances, defaults to 'ec2-user'"
  default     = "ec2-user"
}

variable "common_bootstrap_resources" {
  type        = "string"
  description = "local path to bootstrap resources common to all instances"
  default     = "./ec2/bootstrap/common"
}

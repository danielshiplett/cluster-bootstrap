variable "public_cidr_subnet" {
  type = "string"
}

variable "name" {
  type = "string"
}

variable "clusterid" {
  type        = "string"
  description = "name for cluster"
}

variable "team" {
  type        = "string"
  description = "Value to use for the 'team' tag added to aws resources"
}

variable "project" {
  type        = "string"
  description = "Value to use for the 'project' tag added to aws resources"
}

variable "vpc" {
  type        = "string"
  description = "id for the VPC"
}

variable "igw" {
  type        = "string"
  description = "id for internet gateway"
}

variable "az_index" {
  type        = "string"
  description = "Available AZ's are stored in a list. The AZ within that list to deploy resources in is determined by this index. Note - the actual index used will be az_index % list_size"
  default     = "0"
}

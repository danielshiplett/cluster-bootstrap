# Overview

A Terraform and Ansible based bootstrap for a heterogeneous computing cluster.  Terraform will bring up AWS resources that are needed including a jumpbox for SSH.

# Status

Currently, this is a proof-of-concept.  These are the steps that it successfully completes so far.

* Sets up Terragrunt/Terraform backend in S3 so state can be shared among administrators.
* Terraform creation of all networking components and the jumpbox EC2 instance.
* Ansible based bootstrap that creates accounts for all cluster administrators.
* Ansible based refresh of the jumpbox.

# Todo

* Decide what other features the cluster should have.

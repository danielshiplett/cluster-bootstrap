locals {
  clusterid = "${var.cluster_prefix}-${var.environment}"

  common_instance_metadata = {
    env_name                   = "${var.environment}"
    cluster_prefix             = "${var.cluster_prefix}"
    clusterid                  = "${var.cluster_prefix}${var.environment}"
    dns_domain                 = "${var.dns_domain}"
    dns_subdomain              = "${var.dns_subdomain}"
    team                       = "${var.team}"
    project                    = "${var.project}"
    schedule                   = "${var.schedule}"
    ami                        = "${var.rhel_ami_id}"
    common_bootstrap_resources = "${var.common_bootstrap_resources}"
  }

  jumpbox_host_key = "~/.ssh/${var.cluster_prefix}${var.environment}.${var.dns_domain}.pub"
}

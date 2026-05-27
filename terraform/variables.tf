variable "cluster_name" {
  default = "gitea-platform"
}

variable "my_ip" {
  description = "Allowed CIDRs for EKS API access"
  type        = list(string)
}
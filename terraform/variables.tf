variable "cluster_name" {
  default = "gitea-platform"
}

variable "my_ip" {
  description = "Your IP for EKS API access"
  type        = string
}
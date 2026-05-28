# Security group for EFS - allow NFS (2049) from EKS nodes
resource "aws_security_group" "efs" {
  name        = "gitea-platform-efs"
  description = "Allow NFS traffic from EKS nodes to EFS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "NFS from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gitea-platform-efs"
  }
}

# EFS file system
resource "aws_efs_file_system" "gitea" {
  creation_token = "gitea-platform"
  encrypted      = true

  tags = {
    Name = "gitea-platform"
  }
}

# Mount targets - one per public subnet (nodes live there)
resource "aws_efs_mount_target" "gitea" {
  count           = length(module.vpc.public_subnets)
  file_system_id  = aws_efs_file_system.gitea.id
  subnet_id       = module.vpc.public_subnets[count.index]
  security_groups = [aws_security_group.efs.id]
}

# IRSA role for EFS CSI driver (same pattern as EBS)
module "efs_csi_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.44"

  role_name             = "k8s-test-efs-csi"
  attach_efs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
  }
}

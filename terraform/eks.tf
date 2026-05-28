module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.24"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.my_ip

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  iam_role_use_name_prefix = true
  iam_role_name            = "k8s-test-cluster"

  eks_managed_node_groups = {
    main = {

      instance_types = ["t3.large", "t3a.large", "t2.large"]
      capacity_type  = "SPOT"

      min_size       = 2
      max_size       = 2
      desired_size   = 2

      subnet_ids = module.vpc.public_subnets

      iam_role_use_name_prefix = true
      iam_role_name            = "k8s-test-node"
    }
  }

  enable_cluster_creator_admin_permissions = true
}

module "ebs_csi_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.44"

  role_name             = "k8s-test-ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}


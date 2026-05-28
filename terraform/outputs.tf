output "cluster_name" {
  value = module.eks.cluster_name
}

output "configure_kubectl" {
  value = "aws eks update-kubeconfig --region us-east-1 --name ${module.eks.cluster_name} --profile k8s-test"
}

output "ebs_csi_role_arn" {
  value = module.ebs_csi_irsa.iam_role_arn
}
output "efs_id" {
  value = aws_efs_file_system.gitea.id
}

output "efs_csi_role_arn" {
  value = module.efs_csi_irsa.iam_role_arn
}

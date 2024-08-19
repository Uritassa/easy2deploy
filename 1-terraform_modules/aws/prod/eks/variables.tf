output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.eks.name
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = aws_eks_cluster.eks.arn
}

output "iam_role_arn" {
  description = "The ARN of the IAM role for EKS"
  value       = aws_iam_role.eks.arn
}
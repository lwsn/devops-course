output "cluster_id" {
  description = "ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "Name of the IAM role associated with the EKS cluster"
  value       = module.eks.cluster_iam_role_name
}

output "cluster_iam_role_arn" {
  description = "ARN of the IAM role associated with the EKS cluster"
  value       = module.eks.cluster_iam_role_arn
}

output "node_group_id" {
  description = "ID of the EKS node group"
  value       = module.eks.eks_managed_node_groups["general"].node_group_id
}

output "node_group_arn" {
  description = "ARN of the EKS node group"
  value       = module.eks.eks_managed_node_groups["general"].node_group_arn
}

output "node_group_role_name" {
  description = "Name of the IAM role associated with the EKS node group"
  value       = module.eks.eks_managed_node_groups["general"].iam_role_name
}

output "node_group_role_arn" {
  description = "ARN of the IAM role associated with the EKS node group"
  value       = module.eks.eks_managed_node_groups["general"].iam_role_arn
} 
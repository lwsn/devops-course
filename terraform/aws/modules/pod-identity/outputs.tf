output "role_arn" {
  description = "ARN of the IAM role created for the pod"
  value       = aws_iam_role.pod_role.arn
}

output "role_name" {
  description = "Name of the IAM role created for the pod"
  value       = aws_iam_role.pod_role.name
} 
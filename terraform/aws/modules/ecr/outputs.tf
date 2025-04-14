output "repository_url" {
  description = "The URL of the repository"
  value       = aws_ecr_repository.repo.repository_url
}

output "repository_arn" {
  description = "The ARN of the repository"
  value       = aws_ecr_repository.repo.arn
}

output "repository_name" {
  description = "The name of the repository"
  value       = aws_ecr_repository.repo.name
}

output "repository_registry_id" {
  description = "The registry ID where the repository was created"
  value       = aws_ecr_repository.repo.registry_id
}

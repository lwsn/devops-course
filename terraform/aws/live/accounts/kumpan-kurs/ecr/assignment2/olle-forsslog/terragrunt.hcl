include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = find_in_parent_folders("terraform/aws/modules/ecr")
}

inputs = {
  repository_name = "assignment2/olle-forsslog"
  image_tag_mutability = "MUTABLE"
  scan_on_push = true
  encryption_type = "AES256"
  force_delete = true

  # Optional: Add a lifecycle policy to clean up untagged images
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 5 untagged images"
        selection = {
          tagStatus     = "untagged"
          countType     = "imageCountMoreThan"
          countNumber   = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

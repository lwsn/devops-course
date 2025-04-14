terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Create IAM role for the pod
resource "aws_iam_role" "pod_role" {
  name = "${var.name}-pod-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-pod-role"
    }
  )
}

# Create IAM policy for the role
resource "aws_iam_role_policy" "pod_policy" {
  name = "${var.name}-pod-policy"
  role = aws_iam_role.pod_role.id

  policy = var.policy_json
}

# Create pod identity association
resource "aws_eks_pod_identity_association" "pod_identity" {
  cluster_name    = data.aws_eks_cluster.cluster.name
  namespace       = var.namespace
  service_account = var.service_account
  role_arn        = aws_iam_role.pod_role.arn
}

# Data sources
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
} 
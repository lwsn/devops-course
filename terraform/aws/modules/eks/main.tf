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

# EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.35.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # VPC Configuration
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Cluster IAM Role
  iam_role_name = "kumpan-course-eks-cluster-role"
  
  # Cluster Security Group
  cluster_security_group_name = "kumpan-course-eks-cluster-sg"
  
  # Cluster Encryption
  cluster_encryption_config = {
    resources = ["secrets"]
  }

  # Enable public access to the cluster endpoint
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  access_entries                       = var.access_entries

  # EKS Addons
  cluster_addons = var.cluster_addons

  # EKS Managed Node Groups
  eks_managed_node_groups = {
    general = {
      name           = "kumpan-course-eks-nodes"
      iam_role_name  = "kumpan-course-eks-node-role"
      
      desired_size = var.node_group_desired_size
      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size

      instance_types = var.node_group_instance_types
      capacity_type  = var.node_group_capacity_type
      
      # Node group security group naming
      vpc_security_group_ids = []  # Will use the default security group with custom name
      
      # Node group tags
      tags = {
        Name        = "kumpan-course-eks-nodes"
        Environment = var.environment
        Project     = "kumpan-kurs"
      }
    }
  }

  # Add tags to all resources
  tags = {
    Environment = var.environment
    Project     = "kumpan-kurs"
    ManagedBy   = "terraform"
  }
}

# Create a security group for the EKS cluster that allows access to both public and private subnets
resource "aws_security_group" "eks_cluster" {
  name        = "kumpan-course-eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "kumpan-course-eks-cluster-sg"
    Environment = var.environment
    Project     = "kumpan-kurs"
  }
}

# Allow inbound traffic from the public subnets
resource "aws_security_group_rule" "eks_cluster_from_public" {
  count             = length(var.public_subnet_ids) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.eks_cluster.id
  cidr_blocks       = [for subnet_id in var.public_subnet_ids : data.aws_subnet.public[subnet_id].cidr_block]
}

# Data source to get CIDR blocks of public subnets
data "aws_subnet" "public" {
  for_each = toset(var.public_subnet_ids)
  id       = each.value
} 
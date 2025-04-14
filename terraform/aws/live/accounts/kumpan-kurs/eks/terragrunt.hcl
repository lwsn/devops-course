terraform {
  source = find_in_parent_folders("terraform/aws/modules/eks")
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  cluster_name    = "kumpan-course-eks"
  cluster_version = "1.32"

  # VPC Configuration
  vpc_id                   = dependency.vpc.outputs.vpc_id
  private_subnet_ids       = dependency.vpc.outputs.private_subnet_ids
  control_plane_subnet_ids = dependency.vpc.outputs.private_subnet_ids

  # EKS Addons
  cluster_addons = {
    eks-pod-identity-agent = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    coredns = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
      pod_identity_association = [{
        role_arn        = "arn:aws:iam::289831833738:role/AmazonEKSPodIdentityAmazonEBSCSIDriverRole"
        service_account = "ebs-csi-controller-sa"
      }]
    }
    metrics-server = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size     = 1
      max_size     = 5

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      labels = {
        Environment = "dev"
        Project     = "kumpan-kurs"
      }

      tags = {
        ExtraTag = "eks-node-group"
      }

      # Enable detailed monitoring
      enable_monitoring = true

      # Disk size for the nodes
      disk_size = 50

      # Update configuration
      update_config = {
        max_unavailable_percentage = 33
        max_unavailable           = 2
      }

      # Launch template settings
      launch_template_tags = {
        Name = "kumpan-course-eks-nodes"
      }
    }
  }

  # Cluster configuration
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  # Enable cluster encryption
  cluster_encryption_config = {
    resources = ["secrets"]
  }

  # Enable cluster logging
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Access entries
  access_entries = {
    sso_admin_access = {
      principal_arn = "arn:aws:iam::289831833738:role/aws-reserved/sso.amazonaws.com/eu-north-1/AWSReservedSSO_AdministratorAccess_408733dcd4e56133"
      type = "STANDARD"

      policy_associations = {
        cluster_admin_policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  # Tags for the cluster
  tags = {
    Environment = "dev"
    Project     = "kumpan-kurs"
    ManagedBy   = "terraform"
  }
}

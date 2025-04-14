# EKS Module for Kumpan Kurs

This Terraform module creates an Amazon EKS (Elastic Kubernetes Service) cluster with managed node groups.

## Features

- Creates an EKS cluster with the specified version
- Sets up managed node groups for running Kubernetes workloads
- Configures IAM roles and security groups
- Uses the "kumpan-course" prefix for resource naming
- Tags all resources with Environment and Project tags

## Usage

```hcl
module "eks" {
  source = "./eks"

  vpc_id     = "vpc-0ed80d966c95b931d"
  subnet_ids = ["subnet-0b7f05442e79310ed", "subnet-02089c4328df65836", "subnet-0ab0fa3fdb1dd62a5"]

  # Optional: Override default values
  environment = "dev"
  cluster_version = "1.27"
  node_group_desired_size = 2
}
```

## Requirements

- Terraform >= 1.0.0
- AWS Provider ~> 4.0
- Existing VPC with subnets

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region to deploy resources | string | "eu-north-1" | no |
| aws_profile | AWS profile to use for authentication | string | "kumpan-devops" | no |
| environment | Environment name (e.g., dev, staging, prod) | string | "dev" | no |
| cluster_version | Kubernetes version to use for the EKS cluster | string | "1.27" | no |
| vpc_id | ID of the VPC where the EKS cluster will be deployed | string | n/a | yes |
| subnet_ids | List of subnet IDs for the EKS cluster | list(string) | n/a | yes |
| node_group_desired_size | Desired number of worker nodes in the EKS node group | number | 2 | no |
| node_group_min_size | Minimum number of worker nodes in the EKS node group | number | 1 | no |
| node_group_max_size | Maximum number of worker nodes in the EKS node group | number | 5 | no |
| node_group_instance_types | List of instance types to use for the EKS node group | list(string) | ["t3.medium"] | no |
| node_group_capacity_type | Type of capacity associated with the EKS Node Group | string | "ON_DEMAND" | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | ID of the EKS cluster |
| cluster_arn | ARN of the EKS cluster |
| cluster_endpoint | Endpoint for the EKS control plane |
| cluster_security_group_id | Security group ID attached to the EKS cluster |
| cluster_iam_role_name | Name of the IAM role associated with the EKS cluster |
| cluster_iam_role_arn | ARN of the IAM role associated with the EKS cluster |
| node_group_id | ID of the EKS node group |
| node_group_arn | ARN of the EKS node group |
| node_group_role_name | Name of the IAM role associated with the EKS node group |
| node_group_role_arn | ARN of the IAM role associated with the EKS node group |
| node_group_security_group_id | Security group ID attached to the EKS node group | 
# Kumpan Kurs VPC Configuration

This Terraform configuration creates a VPC for the Kumpan Kubernetes course in the Stockholm (eu-north-1) region. The VPC includes public and private subnets across multiple availability zones, with appropriate route tables and an Internet Gateway.

## Features

- VPC with DNS support enabled
- Public and private subnets in multiple availability zones
- Internet Gateway for public internet access
- Route tables for public and private subnets
- Proper tagging for all resources

## Prerequisites

- Terraform >= 1.0.0
- AWS CLI configured with the `kumpan-devops` profile
- Access to the S3 bucket `btlc-kumpan-devops-tf` for state storage

## Usage

### Initialize Terraform

```bash
terraform init
```

### Plan the Deployment

```bash
terraform plan
```

### Apply the Configuration

```bash
terraform apply
```

### Import Existing VPC (if needed)

If you need to import an existing VPC, use the following command:

```bash
terraform import aws_vpc.kumpan_kurs_vpc vpc-xxxxxxxx
```

Replace `vpc-xxxxxxxx` with the actual VPC ID.

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| aws_region | AWS region to deploy resources | eu-north-1 |
| aws_profile | AWS profile to use for authentication | kumpan-devops |
| environment | Environment name (e.g., dev, staging, prod) | dev |
| vpc_cidr | CIDR block for the VPC | 10.0.0.0/16 |
| availability_zones | List of availability zones to use for subnets | ["eu-north-1a", "eu-north-1b", "eu-north-1c"] |
| public_subnet_cidrs | List of CIDR blocks for public subnets | ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] |
| private_subnet_cidrs | List of CIDR blocks for private subnets | ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"] |

## Outputs

| Output | Description |
|--------|-------------|
| vpc_id | ID of the created VPC |
| vpc_cidr | CIDR block of the created VPC |
| public_subnet_ids | IDs of the public subnets |
| private_subnet_ids | IDs of the private subnets |
| internet_gateway_id | ID of the Internet Gateway |
| public_route_table_id | ID of the public route table |
| private_route_table_ids | IDs of the private route tables | 
# 🎮 Assignment 3: Have Fun!

## 🎯 Purpose
This assignment is designed to give you the freedom to explore and learn! You have AdministratorAccess to a sandbox toy AWS account - feel free to experiment with anything within the AWS or Kubernetes ecosystem, CI/CD or Terraform.

## 🛠️ What You Can Do
- Explore AWS services you're curious about
- Experiment with Kubernetes features
- Build CI/CD pipelines
- Create Terraform configurations
- Combine multiple technologies in interesting ways

## 💡 Examples
Here are some project ideas to get you started:

### Hard Difficulty
- **CI/CD with Github Actions**: Create a workflow that builds and pushes a new docker image to ECR on every commit - and updates an image tag for ArgoCD to deploy to Kubernetes
  - Best practice: Use OIDC (OpenID Connect) where GitHub Actions is allowed to assume an IAM role that has access to ECR and other AWS services
  - This eliminates the need to store AWS credentials as secrets in your GitHub repository
  - Setup requirements:
    - GitHub must be added as an OIDC provider in AWS IAM
    - A custom IAM role must be created with appropriate permissions for ECR and other AWS services
    - The role must have a trust relationship that allows GitHub Actions to assume it
    - Preferably, implement this setup using Terraform to adhere to Infrastructure as Code principles
  - Example Terraform configuration for OIDC setup:
    ```hcl
    # Create GitHub OIDC provider
    resource "aws_iam_openid_connect_provider" "github" {
      url             = "https://token.actions.githubusercontent.com"
      client_id_list  = ["sts.amazonaws.com"]
      thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
    }

    # Create IAM role for GitHub Actions
    resource "aws_iam_role" "github_actions" {
      name = "github-actions-role"

      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRoleWithWebIdentity"
            Effect = "Allow"
            Principal = {
              Federated = aws_iam_openid_connect_provider.github.arn
            }
            Condition = {
              StringLike = {
                "token.actions.githubusercontent.com:sub" : "repo:your-org/your-repo:*"
              }
            }
          }
        ]
      })
    }

    # Attach policy to role
    resource "aws_iam_role_policy_attachment" "github_actions_ecr" {
      role       = aws_iam_role.github_actions.name
      policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
    }
    ```
  - Example Github Actions workflow:
    ```yaml
    name: Build and Deploy
    on:
      push:
        branches: [ main ]
    permissions:
      id-token: write
      contents: read
    jobs:
      build:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v3
          - name: Configure AWS credentials
            uses: aws-actions/configure-aws-credentials@v1
            with:
              role-to-assume: arn:aws:iam::123456789012:role/github-actions-role
              aws-region: eu-north-1
          - name: Login to Amazon ECR
            id: login-ecr
            uses: aws-actions/amazon-ecr-login@v1
          - name: Build, tag, and push image to Amazon ECR
            env:
              ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
              IMAGE_TAG: ${{ github.sha }}
            run: |
              docker build -t $ECR_REGISTRY/${{ github.repository }}:$IMAGE_TAG .
              docker push $ECR_REGISTRY/${{ github.repository }}:$IMAGE_TAG
    ```
- **Event-Driven Architecture**: Create an API that posts something to SQS, and a SQS consumer uploading a document to S3. Tie permissions together with pod identity

### Medium Difficulty
- **Lambda Function**: Create a lambda function that returns a random test personnummer from [Skatteverket's API](https://www7.skatteverket.se/portal/apier-och-oppna-data/utvecklarportalen/oppetdata/Test%C2%AD%C2%ADpersonnummer) ("fun fact": Skatteverket publishes lists of personnummer for development purposes. Automatically generating random personnummer can be a breach of GDPR if you accidentally generate a valid personnummer belonging to an actual person)
- **Infrastructure as Code**: Toy around with Terragrunt/Terraform to manage AWS resources
  - Create a new module for an AWS service you're interested in
  - Set up a Terragrunt configuration that uses DRY (Don't Repeat Yourself) principles
  - Experiment with different Terraform features like workspaces, remote state, or custom providers
  - Try implementing a complex infrastructure pattern like a serverless architecture or a multi-region setup

### Easy Difficulty
- **Helm Chart**: Create a helm chart for assignment 1

## ⚠️ Important Notes
- Feel free to take inspiration from the terraform modules in this repository
- Please try not to destroy the EKS cluster or VPC for everybody else
- If you want to experiment more freely, contact eeemil and you can get a completely isolated AWS account to toy around with during the course

## ✅ Definition of Done
- Do something interesting!

## 🚀 Resources
- [AWS Documentation](https://docs.aws.amazon.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Helm Documentation](https://helm.sh/docs/)
- [GitHub Actions OIDC with AWS](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) 

# Kubernetes, DevOps, and AWS Course

This repository contains the management tools and content for a comprehensive course on Kubernetes, DevOps, and AWS.

## Course Overview

This course is designed to provide a solid foundation in Kubernetes and DevOps practices, with a focus on preparing for the Certified Kubernetes Application Developer (CKAD) certification. The course covers:

- Containerization with Docker
- Kubernetes fundamentals and advanced concepts
- AWS cloud services and infrastructure
- DevOps practices and tools
- Infrastructure as Code with Terraform

While this course provides a strong foundation, additional independent study may be required to pass the CKAD certification exam. The CKAD certification tests your ability to design, build, configure, and expose cloud-native applications for Kubernetes, including working with core primitives, multi-container Pods, storage, security contexts, and service networking.

## Repository Structure

- `assignments/` - Contains course assignments, templates, and solutions
  - [`1-k8sify-application/`](assignments/1-k8sify-application/) - Docker and Kubernetes basics
  - [`2-debug-pod/`](assignments/2-debug-pod/) - Debugging Kubernetes applications
  - [`3-have-fun/`](assignments/3-have-fun/) - Open-ended exploration of AWS and Kubernetes
- `terraform/` - Infrastructure as Code for setting up and managing course environments
  - Uses Terragrunt for managing Terraform configurations, providing DRY (Don't Repeat Yourself) code and consistent environments
- `helm/` - Helm charts for deploying applications and services to Kubernetes
  - `argo-cd/` - Helm chart for deploying Argo CD, a declarative GitOps continuous delivery tool
  - `argo-applications/` - Helm chart for defining Argo CD applications
  - `cert-manager/` - Helm chart for deploying cert-manager, which automates TLS certificate management
  - `external-dns/` - Helm chart for deploying ExternalDNS, which synchronizes Kubernetes services with DNS providers
  - `ingress-nginx/` - Helm chart for deploying NGINX Ingress Controller
  - `postgres/` - Helm chart for deploying PostgreSQL databases
- `scripts/` - Utility scripts for automation, deployment, and environment setup
- `docs/` - Additional documentation and resources
  - [`aws-cli.md`](docs/aws-cli.md) - Configure AWS CLI with SSO, access the course AWS account, and understand AWS authentication methods
  - [`shell-utils.md`](docs/shell-utils.md) - Recommended shell tools and extensions for working with Kubernetes and AWS
  - [`kubectl.md`](docs/kubectl.md) - Essential kubectl commands, namespace management, and Kubernetes operations

## Assignments

### Assignment 1: Docker and Kubernetes Basics
- **Objective**: Containerize a Node.js application and deploy it to Kubernetes
- **Key Skills**: Docker, Kubernetes Deployments, Services, Ingress, and database integration
- **Deliverables**: Dockerfile, Kubernetes manifests, and a working application with caching

### Assignment 2: Debug a Broken Pod
- **Objective**: Debug and fix a deliberately broken Kubernetes application
- **Key Skills**: Kubernetes debugging, troubleshooting, and configuration
- **Deliverables**: Fixed application with all routes working correctly

### Assignment 3: Have Fun!
- **Objective**: Explore AWS and Kubernetes through a self-directed project
- **Key Skills**: AWS services, CI/CD, Infrastructure as Code, and creative problem-solving
- **Deliverables**: A working project that demonstrates understanding of cloud-native concepts

## Prerequisites
- Minimum 1 year of development experience
- Comfort with using the terminal
- Basic understanding of cloud computing concepts

## Security Notice

⚠️ **IMPORTANT**: This repository may contain sensitive information and should not be made public

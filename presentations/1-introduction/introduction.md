---
title: "Kubernetes, DevOps, and AWS"
subtitle: "Introduction presentation"
author: "Emil Marklund"
date: "2025"
institute: "Kumpan Workshop"
theme: moon
colorlinks: true
linkcolor: blue
urlcolor: blue
toccolor: blue
---

<style>
pre {
  background-color: rgb(17, 10, 10) !important;
  color: #f8f8f2 !important;
  border-radius: 5px;
  padding: 15px;
  column-count: 2;
  column-gap: 20px;
  column-fill: balance;
}
code {
  background-color: rgb(17, 10, 10) !important;
  color: #f8f8f2 !important;
}
</style>

# About the Instructor

## Emil Marklund
- DevOps Engineer since ~2017
- Likes k8s, Linux, lifting heavy objects and space stuff
- Lives in the forest
- 150 kg bench press (200 kg squat, 220 kg deadlift)

---

# Required Tools

- **Docker**: Container runtime
- **kubectl**: Kubernetes command-line tool
- **AWS CLI**: AWS command-line interface
- **Terraform/Terragrunt**: Infrastructure as Code

---

# Course Assignments

---

## Getting started

- Clone the course repo and invite `eeemil` on Github so I can help you if you get stuck.

- Accept SSO invite (email) and set up `aws` and `kubectl` (see README in repo)

- Check out Assignments in assignments directory

---

## Assignment 1: Docker and Kubernetes Basics

- Containerize a Node.js application
- Deploy to Kubernetes
- Configure networking and database integration
- Learn Docker and Kubernetes fundamentals

---

## Assignment 2: Debug a Broken Pod

- Debug and fix a deliberately broken Kubernetes application
- Learn troubleshooting techniques
- Understand Kubernetes configuration
- Practice debugging skills

---

## Assignment 3: Have Fun!

- Open-ended exploration of AWS and Kubernetes
- Build a project of your choice
- Apply learned concepts creatively
- Demonstrate understanding of cloud-native principles

---

# CKAD
## Certified Kubernetes Application Developer
- Industry-recognized certification
- Tests practical Kubernetes skills
- Focus on application deployment and management
- Covers core Kubernetes concepts and primitives

---

# IAC

## Infrastructure as Code

- **Terraform**: Declarative infrastructure definition
- **Terragrunt**: DRY (Don't Repeat Yourself) Terraform code
- Consistent environments
- Version-controlled infrastructure
- Automated deployment
- Other tools: CDK, Bicep etc

---

# Kubernetes Core Concepts

---

## What is Kubernetes?

- **Container Orchestration Platform**: Manages and automates containerized applications
- **Declarative configuration**: Define desired state, Kubernetes makes it happen
- **Self-healing**: Automatically restarts failed containers and replaces unhealthy ones

---

## Why Kubernetes?

- **Portability**: Run applications consistently across different environments
- **Scalability**: Automatically scale applications up or down based on demand
- **High Availability**: Distribute workloads across multiple nodes
- **Resource Efficiency**: Optimize resource utilization with containerization
- **Deployment Flexibility**: Rolling updates, canary deployments, blue-green deployments

---

## Cloud Native

- **Definition**: Applications designed to run in cloud environments
- **Key Characteristics**:
  - Containerized
  - Microservices-based
  - Dynamically orchestrated

---

## Cloud Native vs Vendor-Specific

- **Cloud Native**:
  - Platform-agnostic
  - Open standards
  - Portability
- **Vendor-Specific**:
  - Optimized for specific cloud provider
  - Managed services
  - Potential lock-in
- **Cost considerations?**

---

## Services

- **ClusterIP**: Internal communication within the cluster
- **NodePort**: Expose service on a port across all nodes
- **LoadBalancer**: External access with cloud provider integration
- **ExternalName**: DNS aliasing

---

## Service YAML Example

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: 8080
  selector:
    app: my-app
```

---

## Deployments

- Declarative updates for Pods and ReplicaSets
- Rolling updates and rollbacks
- Scaling applications
- Self-healing capabilities

---

## Deployment YAML Example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: my-app:1.0
        ports:
        - containerPort: 8080
```

---

## Ingress

- HTTP/HTTPS routing rules
- Host-based routing
- Path-based routing
- TLS termination
- External access to services

---

## Ingress YAML Example

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-service
            port:
              number: 80
```

---

# Additional Kubernetes Resources

---

## Ingress-NGINX

- NGINX-based Ingress controller
- Advanced routing capabilities
- Custom annotations for configuration
- SSL/TLS termination

---

## External-DNS

- Automatically creates DNS records
- Synchronizes Kubernetes services with DNS providers
- Supports multiple DNS providers
- Simplifies external access

---

## External-DNS Annotations Example

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-dns01"







```

---

## Cert-Manager

- Automated TLS certificate management
- Integration with Let's Encrypt
- Automatic certificate renewal
- Secure communication

---

## Cert-Manager Annotations Example

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-dns01"
    external-dns.alpha.kubernetes.io/hostname: |
      1.presentations.kumpan.btlc.dev









```

---

## Argo-CD

- GitOps continuous delivery tool
- Declarative application deployment
- Synchronization with Git repositories
- Visual application status

---

# Security in AWS/K8S

- **Pod Identity**: Authentication and authorization for pods
- **AWS IAM**: Identity and access management
- **EKS**: Managed Kubernetes service on AWS
- Integration between Kubernetes and AWS services
- Secure access to AWS resources from pods 

---

# Other Clouds

## Cloud Provider Equivalents

---

### Compute Services
- **AWS**: EC2 (Elastic Compute Cloud)
- **GCP**: Compute Engine
- **Azure**: Azure Virtual Machines

---

### Kubernetes Services
- **AWS**: EKS (Elastic Kubernetes Service)
- **GCP**: GKE (Google Kubernetes Engine)
- **Azure**: AKS (Azure Kubernetes Service)

---

### Storage Services
- **AWS**: S3 (Simple Storage Service)
- **GCP**: Cloud Storage
- **Azure**: Azure Blob Storage

---

### Container Registry
- **AWS**: ECR (Elastic Container Registry)
- **GCP**: Container Registry / Artifact Registry
- **Azure**: Azure Container Registry

---

### Pod Identity Solutions
- **AWS**: IAM Roles for Service Accounts (IRSA)
- **GCP**: Workload Identity
- **Azure**: Azure AD Pod Identity

---

### Identity Management
- **AWS**: IAM (Identity and Access Management)
- **GCP**: IAM & Cloud Identity
- **Azure**: Azure AD (Active Directory)

---

### Load Balancers
- **AWS**: ELB (Elastic Load Balancer)
- **GCP**: Cloud Load Balancing
- **Azure**: Azure Load Balancer

---

### Managed Databases
- **AWS**: RDS (Relational Database Service)
- **GCP**: Cloud SQL
- **Azure**: Azure Database for MySQL/PostgreSQL

---

### Key Differences

- **Authentication**: Each provider has unique authentication mechanisms
- **Networking**: Different approaches to VPC/VNet configuration
- **Pricing**: Various pricing models and billing structures
- **Service Integration**: Different levels of integration with other cloud services

---

# Summary

---

## What We've Covered

- **Kubernetes Introduction**: Core concepts, architecture, and key components
- **Kubernetes Resources**: Services, Deployments, Ingress
- **Additional Tools**: Ingress-NGINX, External-DNS, Cert-Manager, and Argo-CD
- **Security in Kubernetes**: Pod identity and AWS integration
- **Course Assignments**: Three hands-on assignments to apply the concepts

---

# Final Notes

---

## Explore the Course Repository


- **Code Examples**: All assignments include complete solutions
- **Terraform Modules**: Infrastructure code for the entire course environment
- **Kubernetes Resources**: Including the configuration for this presentation
- **Documentation**: Guides and references

---

## Experiment and Learn

- **Try New Things**: Feel free to experiment with the environment
- **Break Things**: If something breaks, we can restore it
- **Be Mindful of Costs**: 
  - Don't keep a 1000 node GPU cluster running 24/7
  - ask ChatGPT for costs

---

## Thank You!

- **Questions?**: Feel free to ask during the course on Slack - I'll try to answer as fast as I can
- **Feedback**: Your input helps improve future sessions
- **Resources**: Check the README for additional learning materials
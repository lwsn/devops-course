variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "aws_profile" {
  description = "AWS profile to use for authentication"
  type        = string
  default     = "kumpan-devops"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "name" {
  description = "Name of the pod identity and associated resources"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace where the pod will run"
  type        = string
}

variable "service_account" {
  description = "Kubernetes service account name"
  type        = string
}

variable "policy_json" {
  description = "JSON formatted IAM policy document"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
} 
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = find_in_parent_folders("terraform/aws/modules/pod-identity")
}

dependency "eks" {
  config_path = "${dirname(find_in_parent_folders())}/eks"
}

inputs = {
  name            = "external-dns"
  cluster_name    = dependency.eks.outputs.cluster_name
  namespace       = "external-dns"
  service_account = "external-dns"
  
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "route53:ChangeResourceRecordSets"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:route53:::hostedzone/Z07956813NT4K8VBET8LU",
          "arn:aws:route53:::hostedzone/Z07956813NT4K8VBET8LU/*"
        ]
      },
      {
        Action = [
          "route53:ListTagsForResource",
          "route53:ListResourceRecordSets",
          "route53:ListHostedZones"
        ]
        Effect = "Allow"
        Resource = [
          "*"
        ]
      }
    ]
  })

  tags = {
    Name        = "external-dns-pod-identity"
    Environment = "course"
  }
} 
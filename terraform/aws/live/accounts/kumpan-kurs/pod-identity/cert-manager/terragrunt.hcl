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
  name            = "cert-manager"
  cluster_name    = dependency.eks.outputs.cluster_name
  namespace       = "cert-manager"
  service_account = "cert-manager"

  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["route53:GetChange"]
        Resource = ["arn:aws:route53:::change/*"]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        Resource = ["arn:aws:route53:::hostedzone/*"]
      },
      {
        Effect = "Allow"
        Action = ["route53:ListHostedZonesByName"]
        Resource = ["*"]
      }
    ]
  })

  tags = {
    Name        = "cert-manager-pod-identity"
    Environment = "course"
  }
}

terraform {
  source = find_in_parent_folders("terraform/aws/modules/route53/hosted-zone")
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  domain_name = "kumpan.btlc.dev"

  tags = {
    Environment = "dev"
    Project     = "kumpan-kurs"
    ManagedBy   = "terraform"
  }
} 
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = find_in_parent_folders("terraform/aws/modules/vpc")
}

inputs = {
  vpc_cidr = "172.31.0.0/16"
  availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  public_subnet_cidrs = ["172.31.16.0/20", "172.31.32.0/20", "172.31.0.0/20"]
  private_subnet_cidrs = ["172.31.48.0/20", "172.31.64.0/20", "172.31.80.0/20"]
} 
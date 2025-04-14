remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "btlc-kumpan-devops-tf"
    key     = "kumpan-kurs/${path_relative_to_include()}/terraform.tfstate"
    region  = "eu-north-1"
    profile = "kumpan-devops"
  }
}

# Common variables for all modules
inputs = {
  aws_region  = "eu-north-1"
  aws_profile = "kumpan-devops"
  environment = "dev"
} 
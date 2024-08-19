
locals {
  region        = "eu-central-1"
  provider      = "aws"
  bucket_name   = "YOUR-BUCKET"
  bucket_region = "YOUR-BUCKET-REGION"
  environment   = "dev"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {
    bucket = "${local.bucket_name}"
    key    = "${local.environment}/${local.provider}/${local.region}/${path_relative_to_include()}/terraform.tfstate"
    region = "${local.bucket_region}"
    encrypt = true
  }
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}
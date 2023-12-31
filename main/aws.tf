provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = local.aws_region
  profile    = local.aws_profile
}

data "aws_caller_identity" "current" {
}
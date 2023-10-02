terraform {
  backend "s3" {
    bucket         = "strapi-terraform-bucket"
    key            = "strapi-backend"
    region         = "ap-southeast-1"
    profile        = "myprofile"
    dynamodb_table = "strapi-s3-backend-locktable"
  }
}
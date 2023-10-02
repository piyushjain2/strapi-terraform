resource "aws_ecr_repository" "strapi_ecr_repository" {
    name = "ecr-${var.env_id}-${var.purpose_id}"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
        scan_on_push = true
    }
    tags = {
    environment = var.env_id
    moniker     = var.purpose_id
    createdby   = "Terraform"
  }
}
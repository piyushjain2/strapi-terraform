output "ecr_repository_url" {
  value = aws_ecr_repository.strapi_ecr_repository.repository_url
}

output "ecr_repository_arn" {
  value = aws_ecr_repository.strapi_ecr_repository.arn
}
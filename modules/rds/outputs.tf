output "db_address" {
  value = aws_rds_cluster.strapi_rds_cluster.endpoint
}

output "db_reader_address" {
  value = aws_rds_cluster.strapi_rds_cluster.reader_endpoint
}

output "db_id" {
  value = aws_rds_cluster.strapi_rds_cluster.cluster_resource_id
}

output "db_arn" {
  value = aws_rds_cluster.strapi_rds_cluster.arn
}
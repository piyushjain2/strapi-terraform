resource "aws_kms_key" "strapi_ecs_kms_key" {
  description             = "Strapi KMS key"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "strapi_ecs_cluster_cw_log_group" {
  name = "ecs-cw-lg-${var.env_id}-${var.purpose_id}"
}
resource "aws_ecs_cluster" "strapi_ecs_cluster" {
  name = "ecs-cluster-${var.env_id}-${var.purpose_id}"

    configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.strapi_ecs_kms_key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.strapi_ecs_cluster_cw_log_group.name
      }
    }
  }

  tags = {
    environment = var.env_id
    moniker     = var.purpose_id
    createdby   = "Terraform"
  }
}

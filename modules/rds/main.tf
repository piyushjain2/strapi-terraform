resource "aws_rds_cluster_parameter_group" "strapi_rds_cpg" {
  name        = "${var.env_id}-rds-cluster-pg"
  family      = "aurora-mysql5.7"
  description = "RDS default cluster parameter group"

  parameter {
    name  = "slow_query_log"
    value = "1"
  }
  parameter {
    name  = "long_query_time"
    value = "1"
  }
  parameter {
    name  = "max_allowed_packet"
    value = "41943040"
  }
  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }
  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }
  parameter {
    name  = "collation_connection"
    value = "utf8mb4_unicode_ci"
  }
  parameter {
    name         = "binlog_format"
    value        = "ROW"
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "binlog_checksum"
    value        = "NONE"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_parameter_group" "strapi_rds_pg" {
  name   = "${var.env_id}-rds-pg"
  family = "aurora-mysql5.7"

  parameter {
    name  = "slow_query_log"
    value = "1"
  }
  parameter {
    name  = "long_query_time"
    value = "2"
  }
}

# Security Group
resource "aws_security_group" "strapi_rds_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.env_id}-${var.purpose_id}-db"
  description = "RDS security group for ${var.env_id} ${var.purpose_id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    name        = "${var.env_id}-${var.purpose_id}-db"
    moniker     = var.purpose_id
    environment = var.env_id
    createdby   = "Terraform"
  }
}

resource "aws_rds_cluster" "strapi_rds_cluster" {
  cluster_identifier              = "aurora-cluster-${var.env_id}-${var.purpose_id}"
  availability_zones              = var.azs
  database_name                   = var.database_name
  master_username                 = "admin"
  master_password                 = var.password
  db_subnet_group_name            = var.db_subnet_group
  skip_final_snapshot             = var.skip_final_snapshot
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.11.2"
  storage_encrypted               = var.storage_encrypted
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.strapi_rds_cpg.name
  enabled_cloudwatch_logs_exports = ["error", "slowquery"]
  vpc_security_group_ids          = concat(var.security_group_ids, [aws_security_group.strapi_rds_sg.id])

  snapshot_identifier             = var.snapshot_identifier

  lifecycle {
    ignore_changes = [snapshot_identifier]
  }
}

resource "aws_rds_cluster_instance" "strapi_rds_cluster_instances" {
  count                   = var.node_count
  identifier              = "aurora-cluster-${var.env_id}-${var.purpose_id}-${count.index}"
  cluster_identifier      = aws_rds_cluster.strapi_rds_cluster.id
  instance_class          = var.instance_class
  publicly_accessible     = false
  db_subnet_group_name    = var.db_subnet_group
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.2"
  db_parameter_group_name = aws_db_parameter_group.strapi_rds_pg.name
}
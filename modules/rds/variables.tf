variable "env_id" {
  description = "Unique id for the environment"
}

variable "purpose_id" {
  description = "Purpose for the DB"
}

variable "user_id" {
  description = "IAM ID of the caller which is used in tags"
}

variable "account_id" {
  description = "The AWS Account ID number of the account"
}

variable "aws_region" {
  description = "Name of the AWS region, used by lambda to connect to DB"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  default     = 1
}

variable "db_subnet_group" {
  description = "ID of the database subnet group to use for the cluster"
}

variable "skip_final_snapshot" {
  description = "Shouldw e skip the final snapshot of DB when destroying cluster?"
  default     = false
}

variable "snapshot_rate" {
  description = "How often to take a snapshot"
  default     = "rate(1 hour)"
}

variable "password" {
  description = "Password of the DB"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain automated daily backups for"
  default     = 1
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  default     = "19:00-20:00"
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur, in (UTC)"
  default     = "sat:20:00-sat:21:00"
}

variable "instance_class" {
  description = "DB instance class"
}

variable "security_group_ids" {
  type        = list(string)
  description = "ID of the security group to attach to the cluster"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "database_name" {
  description = "name of the database to be created in db cluster"
  default     = "strapi"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot"
  default     = null
}
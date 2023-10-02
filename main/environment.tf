locals {
  env_id         = replace(terraform.workspace, "default", "staging")
  aws_account_id = data.aws_caller_identity.current.account_id
  moniker        = "strapi-project"
}

locals {
  aws_profile_map = {
    "staging"    = "myprofile"
    "production" = "myprofile"
  }

  aws_profile = local.aws_profile_map[local.env_id]
  # AWS Region
  aws_region_map = {
    "staging"    = "ap-southeast-1"
    "production" = "ap-south-1"
  }
  aws_region = local.aws_region_map[local.env_id]

  cidr_prefix_map = {
    "staging"    = "10.3"
    "production" = "10.6"
  }
  cidr_prefix = local.cidr_prefix_map[local.env_id]

  cluster_node_count_map = {
    "staging"    = 1
    "production" = 3
  }
  cluster_node_count = local.cluster_node_count_map[local.env_id]

  instance_class_map = {
    "staging"    = "db.t3.small"
    "production" = "db.t3.medium"
  }
  instance_class = local.instance_class_map[local.env_id]

  storage_encrypted_map = {
    "staging"    = false
    "production" = false
  }
  storage_encrypted = local.storage_encrypted_map[local.env_id]

  db_name     = "strapi"
  db_username = "admin"
}


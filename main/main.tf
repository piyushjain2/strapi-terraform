# Create VPC
module "vpc_strapi" {
  source = "../modules/vpc"

  env_id      = local.env_id
  purpose_id  = local.moniker
  user_id     = data.aws_caller_identity.current.user_id
  aws_region  = local.aws_region
  azs         = var.azs[local.aws_region]
  cidr_prefix = local.cidr_prefix
}

# Create random DB secret and store it in SecretsManager
module "db_secret_strapi" {
  source = "../modules/password-generation"

  env_id      = local.env_id
  purpose_id  = local.moniker
  secret_name = "db-${local.env_id}-stapi-password"
}

# Create database
module "db_strapi" {
  source = "../modules/rds"

  env_id              = local.env_id
  purpose_id          = local.moniker
  user_id             = data.aws_caller_identity.current.user_id
  account_id          = data.aws_caller_identity.current.account_id
  azs                 = var.azs[local.aws_region]
  aws_region          = local.aws_region
  db_subnet_group     = module.vpc_strapi.db_subnet_group
  skip_final_snapshot = true
  password            = module.db_secret_strapi.plaintext
  node_count          = local.cluster_node_count
  instance_class      = local.instance_class
  storage_encrypted   = local.storage_encrypted
  security_group_ids  = [module.vpc_strapi.db_security_group_id]
  vpc_id              = module.vpc_strapi.vpc_id
  vpc_cidr            = module.vpc_strapi.vpc_cidr_block
}

# Create ECR
module "ecr_server_strapi" {
  source     = "../modules/ecr"
  env_id     = local.env_id
  purpose_id = local.moniker
}

# Create ECS Cluster
module "ecs_cluster_strapi" {
  source = "../modules/ecs/cluster"
  env_id     = local.env_id
  purpose_id = local.moniker  
}
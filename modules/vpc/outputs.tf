output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "public_subnets_cidr_blocks" {
  value = module.vpc.public_subnets_cidr_blocks
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "db_subnet_group" {
  value = module.vpc.database_subnet_group
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "service_security_group_id" {
  value = module.vpc_service_security_group.this_security_group_id
}

output "db_security_group_id" {
  value = module.vpc_db_security_group.this_security_group_id
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

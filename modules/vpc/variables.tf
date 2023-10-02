variable "env_id" {
  description = "Unique id for the environment"
}

variable "purpose_id" {
  description = "Short string to define the purpose of the VPC (used to distinguish VPCs in environemnts with VPCs)"
}

variable "user_id" {
  description = "IAM ID of the caller which is used in tags"
}

variable "aws_region" {
  description = "Set the AWS region"
}

variable "azs" {
  type        = list(string)
  description = "List of AWS availability zones"
}

variable "cidr_prefix" {
  description = "Prefix to use for CIDR blocks/IP Allocation. Include first two octets with one . separator, for example: '10.1'"
}

variable "enable_flow_log" {
  type        = bool
  default     = true
  description = "Whether or not to enable VPC Flow Logs"
}
# Configure VPC, subnets, etc
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.68"

  name = "${var.env_id}-${var.purpose_id}-vpc"
  cidr = "${var.cidr_prefix}.0.0/16"

  azs = var.azs
  private_subnets = slice(
    [
      "${var.cidr_prefix}.1.0/24",
      "${var.cidr_prefix}.2.0/24",
      "${var.cidr_prefix}.3.0/24",
    ],
    0,
    length(var.azs),
  )
  public_subnets = slice(
    [
      "${var.cidr_prefix}.101.0/24",
      "${var.cidr_prefix}.102.0/24",
      "${var.cidr_prefix}.103.0/24",
    ],
    0,
    length(var.azs),
  )
  database_subnets = slice(
    [
      "${var.cidr_prefix}.11.0/24",
      "${var.cidr_prefix}.12.0/24",
      "${var.cidr_prefix}.13.0/24",
    ],
    0,
    length(var.azs),
  )

  enable_nat_gateway           = true
  create_database_subnet_group = true

  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    environment = var.env_id
    createdBy   = "Terraform"
    moniker     = var.purpose_id
  }
}

# VPC flow log - stream to CloudWatch
resource "aws_iam_role" "vpc_flow_log" {
  count = var.enable_flow_log ? 1 : 0
  name = "${var.env_id}-${var.purpose_id}-vpc-flow-log-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_log" {
  count = var.enable_flow_log ? 1 : 0
  name = "${var.env_id}-${var.purpose_id}-vpc-flow-log-policy"
  role = aws_iam_role.vpc_flow_log[0].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  count = var.enable_flow_log ? 1 : 0
  name = "${var.env_id}-${var.purpose_id}-vpc-flow-log"
}

resource "aws_flow_log" "vpc" {
  count = var.enable_flow_log ? 1 : 0
  iam_role_arn    = aws_iam_role.vpc_flow_log[0].arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log[0].arn
  traffic_type    = "ALL"
  vpc_id          = module.vpc.vpc_id
}

# Security Groups

module "vpc_service_security_group" {
  source                 = "terraform-aws-modules/security-group/aws"
  version                = "~> v3.0"

  name                   = "${var.env_id}-${var.purpose_id}-vpc-service-securitygroup"
  description            = "Service security group for ${var.env_id} ${var.purpose_id}"
  vpc_id                 = module.vpc.vpc_id
  use_name_prefix        = false

  ingress_with_self      = [
    {
      from_port          = 0
      to_port            = 65535
      protocol           = "tcp"
    }
  ]

  egress_rules           = ["all-all"]
}

module "vpc_db_security_group" {
  source                 = "terraform-aws-modules/security-group/aws"
  version                = "~> v3.0"

  name                   = "${var.env_id}-${var.purpose_id}-vpc-db-securitygroup"
  description            = "DB security group for ${var.env_id} ${var.purpose_id}"
  vpc_id                 = module.vpc.vpc_id
  use_name_prefix        = false

  ingress_with_self      = [
    {
      from_port          = 3306
      to_port            = 3306
      protocol           = "tcp"
      description        = "MySQL port"
    }
  ]

  egress_rules           = ["all-all"]
}
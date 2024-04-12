provider "aws" {
  region = var.region

  assume_role {
    role_arn = var.aws_account_role_arn
  }
}

module "networking" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.6.0"

  name               = var.environment
  azs                = var.azs
  public_subnets     = var.public_subnet_cidrs
  private_subnets    = var.private_subnet_cidrs
  enable_nat_gateway = true
  enable_vpn_gateway = true
}

module "eks" {
  source                   = "../../modules/eks"
  region                   = var.region
  eks_version              = "1.17"
  api_private_access       = true
  private_api_access_cidrs = [var.vpn_cidr]
  api_public_access        = true
  instance_type            = "c5.large"
  asg_desired              = 3
  asg_min                  = 3
  asg_max                  = 20
  environment              = var.environment
  vpc_id                   = module.networking.vpc_id
  private_subnets          = module.networking.private_subnets
  public_subnets           = module.networking.public_subnets
}


module "rds" {
  source      = "../../modules/rds"
  environment = local.environment

  storage     = 25
  storage_max = 2000

  engine_version = "13.7"
  instance_count = 1
  instance_type  = "db.r6i.xlarge"
  username       = local.user


  ingress_security_groups      = local.ingress_security_groups
  subnets                      = module.networking.private_subnets
  vpc_id                       = module.networking.vpc_id
  deletion_protection          = true
  performance_insights_enabled = true
}

#### etc. for other resources

terraform {
  backend "s3" {
    bucket         = "infrastructure"
    dynamodb_table = "terraform-state-lock"
    key            = "terraform/dev/terraform.tfstate"
    region         = "us-west-2"
    role_arn       = ""
  }
}

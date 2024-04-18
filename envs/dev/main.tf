provider "aws" {
  region = local.region

  assume_role {
    role_arn = local.aws_account_role_arn
  }
}

module "networking" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.6.0"

  name               = local.environment
  azs                = local.azs
  cidr               = local.cidr_block
  public_subnets     = local.public_subnet_cidrs
  private_subnets    = local.private_subnet_cidrs
  enable_nat_gateway = true
  enable_vpn_gateway = true
}

module "eks" {
  source                   = "../../modules/eks"
  name                     = local.environment
  region                   = local.region
  eks_version              = "1.28"
  api_private_access       = true
  private_api_access_cidrs = local.vpc_cidr
  api_public_access        = true
  instance_type            = "c5.large"
  asg_desired              = 3
  asg_min                  = 3
  asg_max                  = 20
  environment              = local.environment
  vpc_id                   = module.networking.vpc_id
  private_subnets          = module.networking.private_subnets
  public_subnets           = module.networking.public_subnets
}

module "fargate_profile" {
  source = "../../modules/fargate-profile"

  name         = "separate-fargate-profile"
  cluster_name = module.eks.cluster_name

  subnet_ids = module.vpc.private_subnets
  selectors = [{
    namespace = "kube-system"
  }]

  tags = merge(local.tags, { Separate = "fargate-profile" })
}


module "traefik" {
  source                 = "../../modules/traefik"
  # dns_record_name        = "*.example.com"
  use_nlb                = false  # Use ELB instead of NLB
  # add_traefik_to_route53 = true
  # public_route53_zone_id = local.public_route53_zone_id


  depends_on = [
    fargate???
  ]
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

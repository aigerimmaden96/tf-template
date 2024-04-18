####
## Common local variables
####
locals {
  region                 = "us-west-2"
  aws_account_role_arn   = ""
  environment            = "your_environment_here"
  azs                    = ["az1", "az2", "az3"]
  vpc_cidr               = ""
  cidr_block             = "10.0.0.0/16"
  public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs   = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  tags                   = ""
}

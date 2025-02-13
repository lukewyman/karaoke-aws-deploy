terraform {
  source = "github.com/lukewyman/karaoke-aws-resources.git//core/vpc"
}

locals {
  environment_hcl = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment     = local.environment_hcl.locals.environment
  aws_region_hcl  = read_terragrunt_config(find_in_parent_folders("_common/aws_region.hcl"))
  aws_region      = local.aws_region_hcl.locals.region
}

inputs = {
  app_name                               = "karaoke"
  aws_region                             = local.aws_region
  environment                            = local.environment
  vpc_cidr_block                         = "10.0.0.0/16"
  vpc_create_database_subnet_route_table = true
  vpc_database_subnets                   = ["10.0.151.0/24", "10.0.152.0/24"]
  vpc_enable_nat_gateway                 = true
  vpc_private_subnets                    = ["10.0.101.0/24", "10.0.102.0/24"]
  vpc_public_subnets                     = ["10.0.1.0/24", "10.0.2.0/24"]
  vpc_single_nat_gateway                 = true
}
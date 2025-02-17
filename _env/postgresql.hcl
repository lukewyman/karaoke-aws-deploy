terraform {
  source = "github.com/lukewyman/karaoke-aws-resources.git//databases/postgresql"
}

locals {
  environment_hcl = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment     = local.environment_hcl.locals.environment
  aws_region_hcl  = read_terragrunt_config(find_in_parent_folders("_common/aws_region.hcl"))
  aws_region      = local.aws_region_hcl.locals.region
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    private_subnets_cidr_blocks = ["", ""]
    public_subnets_cidr_blocks = ["", ""]
    vpc_id = "mock_vpc_id"
  }

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  allocated_storage = 
  app_name    = "karaoke"
  aws_region  = local.aws_region
  db_engine = 
  db_engine_version = 
  db_instance_type = 
  db_port = 
  db_storage_type = 
  db_subnet_ids = 
  environment = local.environment
  private_subnets_cidr_blocks = dependency.vpc.outputs.private_subnets_cidr_blocks
  public_subnets_cidr_blocks = dependency.vpc.outputs.public_subnets_cidr_blocks
  vpc_id = dependency.vpc.outputs.vpc_id
}
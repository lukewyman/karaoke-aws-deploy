terraform {
  source = "github.com/lukewyman/karaoke-aws-resources.git//databases/mongodb"
}

locals {
  environment_hcl = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment     = local.environment_hcl.locals.environment
  aws_region_hcl  = read_terragrunt_config(find_in_parent_folders("_common/aws_region.hcl"))
  aws_region      = local.aws_region_hcl.locals.region
}

dependency "vpc" {
  config_path = "../../core/vpc"

  mock_outputs = {
    database_subnets            = ["mock_subnet_1", "mock_subnet_2"]
    private_subnets_cidr_blocks = ["0.0.0.0/0", "0.0.0.0/0"]
    public_subnets_cidr_blocks = ["0.0.0.0/0", "0.0.0.0/0"]
    vpc_id = "mock_vpc_id"
  }

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  app_name    = "karaoke"
  aws_region  = local.aws_region
  docdb_engine_version = "4.0.0"
  docdb_instance_class = "db.t3.medium"
  docdb_instance_count = 1
  docdb_port = "27017"
  docdb_subnet_ids = dependency.vpc.outputs.database_subnets
  docdb_username = "mongo_admin"
  environment = local.environment
  private_subnets_cidr_blocks = dependency.vpc.outputs.private_subnets_cidr_blocks
  public_subnets_cidr_blocks = dependency.vpc.outputs.public_subnets_cidr_blocks
  vpc_id = dependency.vpc.outputs.vpc_id
}
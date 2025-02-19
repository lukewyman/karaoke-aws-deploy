terraform {
  source = "github.com/lukewyman/karaoke-aws-resources.git//databases/mongodb"
}

locals {
  environment_hcl = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment     = local.environment_hcl.locals.environment
  aws_region_hcl  = read_terragrunt_config(find_in_parent_folders("_common/aws_region.hcl"))
  aws_region      = local.aws_region_hcl.locals.region
}
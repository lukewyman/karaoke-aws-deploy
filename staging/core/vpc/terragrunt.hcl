include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "provider_versions" {
  path = find_in_parent_folders("_common/provider_versions.hcl")
  expose = true
}

locals {
  required_versions = ["aws"]
  provider_versions_template = include.provider_versions.locals.provider_versions_template
  providers_dict = include.provider_versions.locals.provider_versions

  provider_versions = {
    for k, v in local.providers_dict : k => v if contains(local.required_versions, k)    
  } 
}

generate "provider_versions" {

  path = "provider_versions.tf"
  if_exists = "overwrite"

  contents = templatefile(local.provider_versions_template, {
    provider_versions = local.provider_versions
  })

}

terraform {
  source = "github.com/lukewyman/karaoke-aws-resources.git//core/vpc"
}

inputs = {
  app_name                               = "karaoke"
  aws_region                             = "us-west-2"
  environment                            = "stage"
  vpc_cidr_block                         = "10.0.0.0/16"
  vpc_create_database_subnet_route_table = true
  vpc_database_subnets                   = ["10.0.151.0/24", "10.0.152.0/24"]
  vpc_enable_nat_gateway                 = true
  vpc_private_subnets                    = ["10.0.101.0/24", "10.0.102.0/24"]
  vpc_public_subnets                     = ["10.0.1.0/24", "10.0.2.0/24"]
  vpc_single_nat_gateway                 = true
}
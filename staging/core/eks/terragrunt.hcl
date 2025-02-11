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
  source = "github.com/lukewyman/karaoke-aws-resources.git//core/eks-cluster"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    public_subnets = ["mock_subnet_1", "mock_subnet_2"]    
  }

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  app_name                            = "karaoke"
  aws_region                          = "us-west-2"
  cluster_desired_size                = 2
  cluster_endpoint_private_access     = false
  cluster_enpoint_public_access       = true
  cluster_enpoint_public_access_cidrs = ["0.0.0.0/0"]
  cluster_max_size                    = 2
  cluster_min_size                    = 2
  eks_cluster_access_key              = "karaoke-key-pair"
  eks_cluster_public_subnet_ids       = dependency.vpc.outputs.public_subnets
  eks_cluster_service_ipv4_cidr       = "172.20.0.0/16"
  eks_cluster_version                 = "1.32"
  eks_eni_subnet_ids                  = dependency.vpc.outputs.public_subnets
  eks_oidc_ca_thumbprint              = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
  environment                         = "stage"
}
include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  environment_hcl = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment = local.environment_hcl.locals.environment
  aws_region_hcl = read_terragrunt_config(find_in_parent_folders("_common/aws_region.hcl"))
  aws_region = local.aws_region_hcl.locals.region
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
  aws_region                          = local.aws_region
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
  environment                         = local.environment
}
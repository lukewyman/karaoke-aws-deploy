locals {
  environment_hcl = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  environment     = local.environment_hcl.locals.environment
  aws_region_hcl  = read_terragrunt_config(find_in_parent_folders("_common/aws_region.hcl"))
  aws_region      = local.aws_region_hcl.locals.region
}

terraform {
  source = "github.com/lukewyman/karaoke-aws-resources.git//core/flux-bootstrap"
}

dependency "eks" {
  config_path = "../eks"

  mock_outputs = {
    cluster_certificate_authority_data = "bW9ja19jZXJ0X2F1dGhfZGF0YQ=="
    eks_cluster_endpoint               = "mock_cluster_endpoint"
    eks_cluster_id                     = "mock_cluster_id"
  }

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  app_name               = "karaoke"
  aws_region             = local.aws_region
  cluster_ca_certificate = dependency.eks.outputs.cluster_certificate_authority_data
  cluster_endpoint       = dependency.eks.outputs.eks_cluster_endpoint
  eks_cluster_id         = dependency.eks.outputs.eks_cluster_id
  environment            = local.environment
  github_owner           = "lukewyman"
  github_repository      = "karaoke-gitops-flux"
}
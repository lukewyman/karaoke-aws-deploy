include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "provider_versions" {
  path = find_in_parent_folders("_common/provider_versions.hcl")
  expose = true
}

locals {
  required_versions = ["aws", "flux"]
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
  source = "github.com/lukewyman/karaoke-aws-resources.git//core/flux-bootstrap"
}

dependency "eks" {

  config_path = "../eks"

  mock_outputs = {
    cluster_certificate_authority_data = "bW9ja19jZXJ0X2F1dGhfZGF0YQ=="
    eks_cluster_endpoint = "mock_cluster_endpoint"
    eks_cluster_id = "mock_cluster_id"
  }

  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  app_name = "karaoke"
  aws_region = "us-west-2"
  cluster_ca_certificate = dependency.eks.outputs.cluster_certificate_authority_data
  cluster_endpoint = dependency.eks.outputs.eks_cluster_endpoint
  eks_cluster_id = dependency.eks.outputs.eks_cluster_id
  environment = "stage"
  github_owner = "lukewyman"
  github_repository = "karaoke-gitops-flux"
}
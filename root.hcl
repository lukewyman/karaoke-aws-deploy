locals {
  provider_versions_hcl  = read_terragrunt_config(find_in_parent_folders("_common/provider_versions.hcl"))
  required_providers_hcl = read_terragrunt_config("./required_providers.hcl")

  provider_versions          = local.provider_versions_hcl.locals.provider_versions
  provider_versions_template = local.provider_versions_hcl.locals.provider_versions_template
  required_providers         = local.required_providers_hcl.locals.providers

  tofu_required_providers = {
    for k, v in local.provider_versions : k => v if contains(local.required_providers, k)
  }
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket               = "karaoke-tofu-state"
    key                  = "${path_relative_to_include()}/tofu.tfstate"
    encrypt              = true
    dynamodb_table       = "karaoke-tofu-state"
    region               = "us-west-2"
    workspace_key_prefix = "karaoke"
  }
}

generate "provider_versions" {

  path      = "provider_versions.tf"
  if_exists = "overwrite"

  contents = templatefile(local.provider_versions_template, {
    required_providers = local.tofu_required_providers
  })

}


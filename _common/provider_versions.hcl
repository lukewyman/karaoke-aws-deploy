locals {
  provider_versions = {
    aws = { source = "hashicorp/aws", version = "~> 5.84.0" }
    flux = { source = "fluxcd/flux", version = ">= 1.2" }
  }
  provider_versions_template = find_in_parent_folders("_templates/provider_versions.tf.tmpl")
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "eks" {
  path = find_in_parent_folders("_env/databases_iam.hcl")
}
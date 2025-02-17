include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "github_update" {
  path = find_in_parent_folders("_env/github_update.hcl")
}
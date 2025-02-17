include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "flux_bootstrap" {
  path = find_in_parent_folders("_env/flux-bootstrap.hcl")
}
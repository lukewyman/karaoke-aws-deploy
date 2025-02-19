include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "eks" {
  path = find_in_parent_folders("_env/irsa.hcl")
}
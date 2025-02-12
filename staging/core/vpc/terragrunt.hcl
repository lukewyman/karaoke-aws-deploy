include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "vpc" {
  path = find_in_parent_folders("_env/vpc.hcl")
}

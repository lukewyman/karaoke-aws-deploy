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



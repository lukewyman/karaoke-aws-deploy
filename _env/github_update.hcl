terraform {
  source = "github.com/lukewyman/karaoke-aws-resources.git//gitops/github-update"
}

inputs = {
  app_name = "karaoke"
  namespace = "karaoke"
  github_repository_name = "test-tofu-github-provider"

  kustomize_patches = {
    "mongodb-named-service" = {
      github_file = "named-services/mongodb-svc.yaml"
      template = "named-service.tftpl"
      vars = {
        service_name = "mongodb"
        external_name = "mongodb://user:pass@song-library"
      }
    }

    "postgresql-named_service" = {
      github_file = "named-services/postgresql-svc.yaml"
      template = "named-service.tftpl"
      vars = {
        service_name = "postgresql"
        external_name = "postrgresql://user:pass@singers"
      }
    }

    "song-library-service_account" = {
      github_file = "service-accounts/song-library-sa.yaml"
      template = "service-account.tftpl"
      vars = {
        service_account_name = "song-library-sa"
        iam_role_annotation = "eks/song-library-iam-role-arn"
      }
    }

    "singers-service-account" = {
      github_file = "service-accounts/singers-sa.yaml"
      template = "service-account.tftpl"
      vars = {
        service_account_name = "singers-sa"
        iam_role_annotation = "eks/singers-iam-role-arn"
      }
    }

    "rotations-service-acccount" = {
      github_file = "service-accounts/rotations-sa.yaml"
      template = "service-account.tftpl"
      vars = {
        service_account_name = "rotations-sa"
        iam_role_annotation = "eks/rotations-iam-role-arn"
      }
    }
  }
    
}

# acme-backend

## Installation
Add module from the private registry
Call the module with
#### main.tf
```hcl
module "demo-module" {
  for_each = var.workspaces_to_deploy
  source              = "app.terraform.io/ACME-backend-organization/acme-backend-module/tfc"
  version             = "1.0.0"
  github_organization = each.value.github_organization
  tfe_organization    = each.value.tfe_organization
  workspace_settings = {
    name = each.value.workspace_settings.name
    auto_destroy_activity_duration = try(each.value.workspace_settings.auto_destroy_activity_duration, null)
    vcs_repo = {
      branch     = each.value.workspace_settings.vcs_repo.branch
      identifier = each.value.workspace_settings.vcs_repo.identifier
    }
  }
}
```
#### terraform.tvars
```hcl
workspaces_to_deploy = {
  prod = {
    github_organization = "person"
    tfe_organization    = "ACME-Segregated-Environments"

    workspace_settings = {
      name = "prod"
      vcs_repo = {
        branch     = "master"
        identifier = "hnrikcrlstn/terraform-acme-segregated-environments"
      }
    }
  }

  staging = {
    github_organization = "hnrikcrlstn"
    tfe_organization    = "ACME-Segregated-Environments"

    workspace_settings = {
      name                           = "acme-demo-staging"
      auto_destroy_activity_duration = "1d"
      vcs_repo = {
        branch     = "staging"
        identifier = "hnrikcrlstn/terraform-acme-segregated-environments"
      }
    }
  }

  dev = {
    github_organization = "hnrikcrlstn"
    tfe_organization    = "ACME-Segregated-Environments"

    workspace_settings = {
      name                           = "acme-demo-dev"
      auto_destroy_activity_duration = "1d"
      vcs_repo = {
        branch     = "dev"
        identifier = "hnrikcrlstn/terraform-acme-segregated-environments"
      }
    }
  }
}
```

## Usage
When the devs at ACME updates the branch master, staging or dev, the corresponding workspace in Terraform Cloud will update.
To prevent overdue dev and staging environments, they will auto destroy if they are left inactive for 1 day
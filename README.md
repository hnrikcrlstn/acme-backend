# acme-backend

### Installation
Add module from the private registry
Call the module with
```hcl
module "demo-module" {
  for_each = var.workspaces_to_deploy
  source              = "app.terraform.io/hcarlstein/demo-module/tfe"
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
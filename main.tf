terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.71.0"
    }
  }
}

variable "github_organization" {
  type = string
}

variable "tfe_organization" {
  type = string
}

variable "workspace_settings" {
  type = object({
    name                           = string
    auto_destroy_activity_duration = optional(string)
    vcs_repo = object({
      branch     = string
      identifier = string
    })
  })
}

data "tfe_github_app_installation" "this" {
  name = var.github_organization
}

resource "tfe_workspace" "this" {
  name         = var.workspace_settings.name
  organization = var.tfe_organization

  auto_destroy_activity_duration = try(
    var.workspace_settings.auto_destroy_activity_duration,
    null
  )

  vcs_repo {
    branch                     = var.workspace_settings.vcs_repo.branch
    identifier                 = var.workspace_settings.vcs_repo.identifier
    github_app_installation_id = data.tfe_github_app_installation.this.id
  }
}

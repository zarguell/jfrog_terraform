terraform {
  required_providers {
    artifactory = {
      source  = "jfrog/artifactory"
      version = "12.5.1"
    }
    project = {
      source  = "jfrog/project"
      version = "1.9.1"
    }
  }
}

provider "artifactory" {
  url          = var.artifactory_url
  access_token = var.artifactory_access_token
}

provider "project" {
  url          = var.artifactory_url
  access_token = var.artifactory_access_token
}

# Create the project
resource "project" "ext" {
  key          = "ext"
  display_name = "External Project"
  description  = "External Project"
  admin_privileges {
    manage_members   = true
    manage_resources = true
    index_resources  = true
  }
  max_storage_in_gibibytes   = 10
  block_deployments_on_limit = false
  email_notification         = true
}


# Remote Conda Repos
module "remote_conda" {
  for_each    = local.conda_remote_repos
  source      = "./modules/remote_conda_repo"
  repo_key    = each.key
  repo_url    = each.value
  project_key = local.project_key
}

# Virtual Conda Repos
module "virtual_conda" {
  for_each    = local.virtual_conda_repos
  source      = "./modules/virtual_conda_repo"
  repo_key    = each.key
  repositories = [
    for repo in each.value : module.remote_conda[repo].repo_key
  ]
  project_key = local.project_key
}

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

variable "repo_key" {}
variable "repo_url" {}
variable "repo_layout" {
  default = "simple-default"
}
variable "project_key" {}
variable "envs" {
  type    = list(string)
  default = ["DEV"]
}

resource "artifactory_remote_conda_repository" "this" {
  key                  = var.repo_key
  url                  = var.repo_url
  repo_layout_ref      = var.repo_layout
  project_key          = var.project_key
  project_environments = var.envs
}

output "repo_key" {
  value = artifactory_remote_conda_repository.this.key
}

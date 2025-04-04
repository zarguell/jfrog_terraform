import os
import sys

TERRAFORM_HEADER = """terraform {
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
"""

REMOTE_TEMPLATE = """{header}

variable "repo_key" {{}}
variable "repo_url" {{}}
variable "repo_layout" {{
  default = "simple-default"
}}
variable "project_key" {{}}
variable "envs" {{
  type    = list(string)
  default = ["DEV"]
}}

resource "artifactory_remote_{type}_repository" "this" {{
  key                  = var.repo_key
  url                  = var.repo_url
  repo_layout_ref      = var.repo_layout
  project_key          = var.project_key
  project_environments = var.envs
}}

output "repo_key" {{
  value = artifactory_remote_{type}_repository.this.key
}}
"""

VIRTUAL_TEMPLATE = """{header}

variable "repo_key" {{}}
variable "repositories" {{
  type = list(string)
}}
variable "repo_layout" {{
  default = "simple-default"
}}
variable "project_key" {{}}
variable "envs" {{
  type    = list(string)
  default = ["DEV"]
}}

resource "artifactory_virtual_{type}_repository" "this" {{
  key                  = var.repo_key
  repositories         = var.repositories
  repo_layout_ref      = var.repo_layout
  project_key          = var.project_key
  project_environments = var.envs
}}
"""

def create_module(repo_type):
    repo_type = repo_type.lower()
    remote_dir = f"modules/remote_{repo_type}_repo"
    virtual_dir = f"modules/virtual_{repo_type}_repo"

    os.makedirs(remote_dir, exist_ok=True)
    os.makedirs(virtual_dir, exist_ok=True)

    with open(os.path.join(remote_dir, "main.tf"), "w") as remote_file:
        remote_file.write(REMOTE_TEMPLATE.format(header=TERRAFORM_HEADER, type=repo_type))

    with open(os.path.join(virtual_dir, "main.tf"), "w") as virtual_file:
        virtual_file.write(VIRTUAL_TEMPLATE.format(header=TERRAFORM_HEADER, type=repo_type))

    print(f"Modules created for repo type '{repo_type}' in:")
    print(f" - {remote_dir}/main.tf")
    print(f" - {virtual_dir}/main.tf")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python create_terraform_module.py <repo_type>")
        sys.exit(1)

    repo_type_arg = sys.argv[1]
    create_module(repo_type_arg)

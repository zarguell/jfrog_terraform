locals {
  project_key = project.ext.key

  conda_remote_repos = {
    "ext-conda-main-remote"  = "https://repo.anaconda.com/pkgs/main"
    "ext-conda-msys2-remote" = "https://repo.anaconda.com/pkgs/msys2"
  }

  virtual_conda_repos = {
    "ext-conda" = [
      "ext-conda-main-remote",
      "ext-conda-msys2-remote"
    ]
  }

  docker_remote_repos = {
    "ext-docker-dockerhub"  = "https://registry-1.docker.io"
  }

  virtual_docker_repos = {
    "ext-docker" = [
      "ext-docker-dockerhub"
    ]
  }
}

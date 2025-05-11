# General
locals {
  repository_name = format("terraform-azure-%s", var.usecase)
}
# Azure.Identity
locals {
  app_name       = format("%s-github-actions", var.usecase)
  subject_prefix = format("repo:%s/%s", var.github_organization, local.repository_name)
  subjects = {
    "branch" = format("%s:ref:refs/heads/main", local.subject_prefix)
  }
}
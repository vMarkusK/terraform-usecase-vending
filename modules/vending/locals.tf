# General
locals {
  repository_name = format("terraform-azure-%s", var.usecase)
}
# Azure.Identity
locals {
  app_name       = format("%s-github-actions", var.usecase)
  subject_prefix = format("repo:%s/%s", var.github_organization, local.repository_name)
  subjects = {
    "environment" = format("%s:environment:", local.subject_prefix)
    "branch"      = format("%s:ref:refs/heads/main", local.subject_prefix)
  }
}

# GitHub.Codebase
locals {
  environments = [
    "dev",
    "prod"
  ]
  tf_files = [
    "main.tf",
    "locals.tf",
    "outputs.tf",
    "variables.main.tf"
  ]
  wf_files = [
    "Test.yml",
    "ValidateAndDeploy.yml",
    "ValidateAndPlan.yml"
  ]
  vscode_files = [
    "extensions.json",
    "settings.json"
  ]
}

# Azure.Storage
locals {
  rg_name  = "rg-state-${var.usecase}-${random_string.suffix.result}"
  uai_name = "uai-${var.usecase}-${random_string.suffix.result}"
  kv_name  = "kv-${var.usecase}-${random_string.suffix.result}"
  key_name = "cmk-${var.usecase}-${random_string.suffix.result}"
  st_name  = "ststate${var.usecase}${random_string.suffix.result}"
}
resource "github_repository_environment" "this" {
  for_each = { for environment in local.environments : environment.name => environment }

  environment = each.value.name
  repository  = local.repository_name

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }

}

resource "github_actions_environment_variable" "tfvars" {
  for_each = github_repository_environment.this

  repository    = local.repository_name
  environment   = github_repository_environment.this[each.key].environment
  variable_name = "VAR_FILE"
  value         = format("%s.tfvars", github_repository_environment.this[each.key].environment)
}

resource "github_actions_environment_variable" "tfbackend" {
  for_each = github_repository_environment.this

  repository    = local.repository_name
  environment   = github_repository_environment.this[each.key].environment
  variable_name = "BACKEND_FILE"
  value         = format("%s.tfbackend", github_repository_environment.this[each.key].environment)
}
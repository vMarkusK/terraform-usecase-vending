resource "github_repository_environment" "this" {
  for_each = toset(local.environments)

  environment = each.key
  repository  = local.repository_name

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }

}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 10"
  }

  depends_on = [github_repository_environment.this]
}

resource "github_actions_environment_variable" "tfvars" {
  for_each = github_repository_environment.this

  repository    = local.repository_name
  environment   = github_repository_environment.this[each.key].environment
  variable_name = "VAR_FILE"
  value         = format("%s.tfvars", github_repository_environment.this[each.key].environment)

  depends_on = [null_resource.delay]
}

resource "github_actions_environment_variable" "tfbackend" {
  for_each = github_repository_environment.this

  repository    = local.repository_name
  environment   = github_repository_environment.this[each.key].environment
  variable_name = "BACKEND_FILE"
  value         = format("%s.tfbackend", github_repository_environment.this[each.key].environment)

  depends_on = [null_resource.delay]
}

resource "github_actions_environment_secret" "subscription_id" {
  for_each = github_repository_environment.this

  repository      = local.repository_name
  environment     = github_repository_environment.this[each.key].environment
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = var.subscription_id

  depends_on = [null_resource.delay]
}

resource "github_actions_environment_secret" "tenant_id" {
  for_each = github_repository_environment.this

  repository      = local.repository_name
  environment     = github_repository_environment.this[each.key].environment
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azuread_client_config.this.tenant_id

  depends_on = [null_resource.delay]
}

resource "github_actions_environment_secret" "client_id" {
  for_each = github_repository_environment.this

  repository      = local.repository_name
  environment     = github_repository_environment.this[each.key].environment
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = azuread_application.this.client_id

  depends_on = [null_resource.delay]
}

resource "github_actions_environment_secret" "state_rg" {
  for_each = github_repository_environment.this

  repository      = local.repository_name
  environment     = github_repository_environment.this[each.key].environment
  secret_name     = "STATE_RESOURCE_GROUP"
  plaintext_value = azurerm_resource_group.this.name

  depends_on = [null_resource.delay]
}

resource "github_actions_environment_secret" "state_st" {
  for_each = github_repository_environment.this

  repository      = local.repository_name
  environment     = github_repository_environment.this[each.key].environment
  secret_name     = "STATE_STORAGE_ACCOUNT"
  plaintext_value = azurerm_storage_account.this.name

  depends_on = [null_resource.delay]
}
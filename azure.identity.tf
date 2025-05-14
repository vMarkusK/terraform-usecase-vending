resource "azuread_application" "this" {
  display_name = local.app_name
  description  = "Deployments for ${var.github_organization}-${local.repository_name}"
}

resource "azuread_service_principal" "this" {
  client_id                    = azuread_application.this.client_id
  app_role_assignment_required = false
}

resource "azuread_application_federated_identity_credential" "this" {
  for_each = toset(local.environments)

  display_name   = format("%s-%s", local.app_name, each.key)
  application_id = azuread_application.this.id
  description    = "Deployments for ${var.github_organization}-${local.repository_name}"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = format("%s%s", local.subjects["environment"], each.key)
}

resource "azurerm_role_assignment" "contributor" {
  scope                            = data.azurerm_subscription.this.id
  role_definition_name             = "Contributor"
  principal_id                     = azuread_service_principal.this.object_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "blob_owner" {
  scope                            = azurerm_storage_account.this.id
  role_definition_name             = "Storage Blob Data Owner"
  principal_id                     = azuread_service_principal.this.object_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "keyvault_admin" {
  scope                            = data.azurerm_subscription.this.id
  role_definition_name             = "Key Vault Data Access Administrator"
  principal_id                     = azuread_service_principal.this.object_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}


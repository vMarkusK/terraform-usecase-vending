resource "azuread_application" "this" {
  display_name = local.app_name
  description  = "Deployments for ${var.github_organization}-${local.repository_name}"
}

resource "azuread_service_principal" "this" {
  client_id                    = azuread_application.this.client_id
  app_role_assignment_required = false
}

resource "azuread_application_federated_identity_credential" "this" {
  display_name   = local.app_name
  application_id = azuread_application.this.id
  description    = "Deployments for ${var.github_organization}-${local.repository_name}"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = local.subjects["branch"]
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


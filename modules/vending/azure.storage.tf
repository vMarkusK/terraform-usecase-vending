resource "time_static" "current" {}

data "http" "icanhazip" {
  url = "http://ipv4.icanhazip.com"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric = true
  lower   = true
}

resource "azurerm_resource_group" "this" {
  name     = local.rg_name
  location = var.location
}

resource "azurerm_user_assigned_identity" "this" {
  name                = local.uai_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_key_vault" "this" {
  name                = local.kv_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  sku_name                   = "standard"
  tenant_id                  = data.azuread_client_config.this.tenant_id
  enable_rbac_authorization  = true
  purge_protection_enabled   = true
  soft_delete_retention_days = 7

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = ["${chomp(data.http.icanhazip.response_body)}/32"]
  }

}

resource "azurerm_role_assignment" "uai" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_key_vault_key" "this" {
  name         = local.key_name
  key_vault_id = azurerm_key_vault.this.id


  key_type = "RSA"
  key_size = 4096
  key_opts = ["wrapKey", "unwrapKey"]

  expiration_date = timeadd(formatdate("YYYY-MM-DD'T'HH:mm:ss'Z'", time_static.current.rfc3339), "8760h")

  rotation_policy {
    automatic {
      time_before_expiry = "P60D"
    }

    expire_after         = "P365D"
    notify_before_expiry = "P30D"
  }

  lifecycle {
    ignore_changes = [expiration_date]
  }
}

resource "azurerm_storage_account" "this" {
  name                = local.st_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  access_tier              = "Hot"
  account_replication_type = "ZRS"

  public_network_access_enabled    = true
  https_traffic_only_enabled       = true
  min_tls_version                  = "TLS1_2"
  shared_access_key_enabled        = false
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  sftp_enabled                     = false
  local_user_enabled               = false
  queue_encryption_key_type        = "Account"
  table_encryption_key_type        = "Account"


  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.this.id
    ]
  }

  customer_managed_key {
    key_vault_key_id          = azurerm_key_vault_key.this.id
    user_assigned_identity_id = azurerm_user_assigned_identity.this.id
  }

  network_rules {
    default_action = "Deny"
    bypass         = ["Logging", "Metrics", "AzureServices"]
    ip_rules       = ["${chomp(data.http.icanhazip.response_body)}"]
  }

  share_properties {
    retention_policy {
      days = 14
    }
  }

  blob_properties {
    change_feed_enabled           = true
    change_feed_retention_in_days = 60
    versioning_enabled            = true

    restore_policy {
      days = 7
    }

    container_delete_retention_policy {
      days = 14
    }

    delete_retention_policy {
      days = 14
    }

  }

  depends_on = [azurerm_key_vault.this, azurerm_role_assignment.uai]
}

resource "azurerm_storage_management_policy" "this" {
  storage_account_id = azurerm_storage_account.this.id

  rule {
    name    = "cleanup"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      snapshot {
        delete_after_days_since_creation_greater_than = 30
      }
      version {
        delete_after_days_since_creation = 30
      }
    }
  }
}

resource "azurerm_storage_container" "this" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}
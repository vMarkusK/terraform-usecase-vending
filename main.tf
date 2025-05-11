terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.25.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.3"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.0.2"
    }
  }
  required_version = ">= 1.10.5"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id

  storage_use_azuread = true
}

data "azuread_client_config" "this" {}

data "azurerm_subscription" "this" {}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.28"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.7"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.3"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.6"
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
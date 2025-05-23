terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.28.0"
    }
  }
  backend "azurerm" {}
  required_version = "~> 1.12.0"
}

provider "azurerm" {
  features {}
  subscription_id     = var.subscription_id
  storage_use_azuread = true
}

resource "azurerm_resource_group" "this" {
  name     = local.rg_name
  location = var.location
}
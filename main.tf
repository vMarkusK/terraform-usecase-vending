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
    time = {
      source  = "hashicorp/time"
      version = ">= 0.13"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.5"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-core-infra-001"
    storage_account_name = "stcoreinfrastate001"
    container_name       = "usecasevending"
    key                  = "prod.tfstate"
    use_azuread_auth     = true
  }
  required_version = ">= 1.12.0"
}

provider "azurerm" {
  features {}
  subscription_id     = var.subscription_id
  storage_use_azuread = true
}

data "azuread_client_config" "this" {}

data "azurerm_subscription" "this" {}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.69.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.8.1"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.8.0"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.11.1"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.13.1"
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

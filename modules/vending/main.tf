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
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.4"
    }
  }
  required_version = ">= 1.12.0"
}

data "azuread_client_config" "this" {}

data "azurerm_subscription" "this" {}
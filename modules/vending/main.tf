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
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2"
    }
  }
  required_version = ">= 1.12.0"
}

data "azuread_client_config" "this" {}

data "azurerm_subscription" "this" {}
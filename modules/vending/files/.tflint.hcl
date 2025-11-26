config {
    call_module_type = "local"  
    varfile = ["environments/dev.tfvars", "environments/prod.tfvars"]
}

plugin "azurerm" {
    enabled = true
    version = "0.30.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

plugin "terraform" {
    enabled = true
    preset  = "recommended"
}

rule "azurerm_resources_missing_prevent_destroy" {
  enabled = false
}

rule "terraform_naming_convention" {
    enabled = true

    variable {
        format = "snake_case"
    }

    locals {
        format = "snake_case"
    }

    output {
        format = "snake_case"
    }

    resource {
        format = "snake_case"
    }

    module {
        format = "snake_case"
    }

    data {
        format = "snake_case"
    }
}

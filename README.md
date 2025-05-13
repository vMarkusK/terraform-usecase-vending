# Terraform Usecase Vending for Azure

- Reference: <https://github.com/Azure-Terraformer/terraform-github-atat/blob/main/modules/azure-fn-core/README.md>
- AddOn
  - State Store
  - My Pipelines

## Helper

Reqzurements:

- Azure CLI
- GitHub CLI

### GitHub

GitHub Login

```
gh auth login -h github.com 
```

GitHub Token Refresh

```
gh auth refresh -h github.com 
```

### Azure

Azure Login

```
az login
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.3 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 3.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.28 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 6.6 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.5 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.7 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.2 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 3.3 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.28 |
| <a name="provider_github"></a> [github](#provider\_github) | >= 6.6 |
| <a name="provider_http"></a> [http](#provider\_http) | >= 3.5 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.7 |
| <a name="provider_template"></a> [template](#provider\_template) | >= 2.2 |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.13 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_federated_identity_credential.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential) | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.uai](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_management_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [github_actions_environment_variable.tfbackend](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_variable) | resource |
| [github_actions_environment_variable.tfvars](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_variable) | resource |
| [github_actions_variable.application_name](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_branch.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch) | resource |
| [github_branch_default.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_environment.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment) | resource |
| [github_repository_file.github_devcontainer](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.github_env_tfbackend](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.github_env_tfvars](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.github_tf_files](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.github_wf_files](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.gitignore](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.tflint](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [github_repository_file.vscode_settings](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [time_static.current](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azuread_client_config.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [github_user.current](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/user) | data source |
| [http_http.icanhazip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [template_file.env_tfbackend](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_commit_user"></a> [commit\_user](#input\_commit\_user) | The GitHub identity used to commit the workflow YAML file to the repository.<br/><br/>This includes:<br/>- **name**: The name of the user committing the workflow file.<br/>- **email**: The email address of the user committing the workflow file.<br/><br/>Ensure that the provided Git identity has the necessary permissions to push changes to the specified repository and branch. | <pre>object({<br/>    name  = string<br/>    email = string<br/>  })</pre> | n/a | yes |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | GitHub organization name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location for all resources | `string` | `"germanywestcentral"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription ID for all resources | `string` | n/a | yes |
| <a name="input_usecase"></a> [usecase](#input\_usecase) | UseCase Shortname | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
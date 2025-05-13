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
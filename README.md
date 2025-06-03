# Terraform Usecase Vending for Azure

Inspiration: <https://github.com/Azure-Terraformer/terraform-github-atat/blob/main/modules/azure-fn-core/README.md>

## Features

**Creates a EntraID Federated Identity Credential**

**Creates a Azure Storage Account for Terraform Remote State**

- Including CMK Encryption
- Including Security Hardening

**Creates a GitHub Repo**

- Including two Environments
  - Including Secrets and Variables for Deployment

**Adds Basic Codebase for Terraform Azure Projects**

- Including GitHub Copilot Instructions
- Including GitHub Devcontainer File
- Including GitHub Actions for Deployment
- Including VSCode Config
- Including TFLint Config

```
├── .github
│   ├── copilot-instructions.md
│   ├── devcontainer.json
│   └── workflows
│       ├── Test.yml
│       ├── ValidateAndDeploy.yml
│       └── ValidateAndPlan.yml
├── .gitignore
├── .tflint.hcl
├── .vscode
│   ├── extensions.json
│   └── settings.json
├── README.md
├── environments
│   ├── dev.tfbackend
│   ├── dev.tfvars
│   ├── prod.tfbackend
│   └── prod.tfvars
├── locals.tf
├── main.tf
├── outputs.tf
└── variables.main.tf
```

## Helper

Requirements:

- Azure CLI
- GitHub CLI

### GitHub

GitHub Login

```
gh auth login -h github.com 
```

GitHub Token Refresh prior destroy

```
gh auth refresh -h github.com -s delete_repo
```

### Azure

Azure Login

```
az login
```
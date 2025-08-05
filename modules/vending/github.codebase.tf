resource "github_repository_file" "gitignore" {
  repository          = github_repository.this.name
  branch              = "main"
  file                = ".gitignore"
  content             = file("${path.module}/files/.gitignore")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}

resource "github_repository_file" "devcontainer" {
  repository          = github_repository.this.name
  branch              = "main"
  file                = ".devcontainer/devcontainer.json"
  content             = file("${path.module}/files/devcontainer.json")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}

resource "github_repository_file" "tflint" {
  repository          = github_repository.this.name
  branch              = "main"
  file                = ".tflint.hcl"
  content             = file("${path.module}/files/.tflint.hcl")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}

resource "github_repository_file" "trivy" {
  repository          = github_repository.this.name
  branch              = "main"
  file                = "trivy.yaml"
  content             = file("${path.module}/files/trivy.yaml")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}

resource "github_repository_file" "vscode_settings" {
  for_each = toset(local.vscode_files)

  repository          = github_repository.this.name
  branch              = "main"
  file                = format(".vscode/%s", each.key)
  content             = file("${path.module}/files/vscode_${each.key}")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}

resource "github_repository_file" "github_settings" {
  for_each = toset(local.github_files)

  repository          = github_repository.this.name
  branch              = "main"
  file                = format(".github/%s", each.key)
  content             = file("${path.module}/files/github_${each.key}")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}

data "template_file" "env_tfvars" {
  for_each = toset(local.environments)

  template = file("${path.module}/files/tfvars.tftpl")
  vars = {
    subscr_id = var.subscription_id
    env       = each.key
    usecase   = var.usecase
    suffix    = random_string.suffix.result
  }
}

resource "github_repository_file" "github_env_tfvars" {
  for_each = toset(local.environments)

  repository          = github_repository.this.name
  branch              = "main"
  file                = format("environments/%s.tfvars", each.key)
  content             = data.template_file.env_tfvars[each.key].rendered
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [
      content
    ]
  }
}

data "template_file" "env_tfbackend" {
  for_each = toset(local.environments)

  template = file("${path.module}/files/tfbackend.tftpl")
  vars = {
    rg_name  = local.rg_name
    st_name  = local.st_name
    key_name = format("%s.tfstate", each.key)
  }
}

resource "github_repository_file" "github_env_tfbackend" {
  for_each = toset(local.environments)

  repository          = github_repository.this.name
  branch              = "main"
  file                = format("environments/%s.tfbackend", each.key)
  content             = data.template_file.env_tfbackend[each.key].rendered
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}


resource "github_repository_file" "github_tf_files" {
  for_each = toset(local.tf_files)

  repository          = github_repository.this.name
  branch              = "main"
  file                = each.key
  content             = file("${path.module}/files/${each.key}")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [
      content
    ]
  }
}

resource "github_repository_file" "github_wf_files" {
  for_each = toset(local.wf_files)

  repository          = github_repository.this.name
  branch              = "main"
  file                = format(".github/workflows/%s", each.key)
  content             = file("${path.module}/files/workflow_${each.key}")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true

  depends_on = [
    github_repository_file.gitignore,
    github_repository_file.devcontainer,
    github_repository_file.tflint,
    github_repository_file.vscode_settings,
    github_repository_file.github_settings,
    github_repository_file.github_env_tfvars,
    github_repository_file.github_env_tfbackend,
    github_repository_file.github_tf_files,
    github_repository_environment.this,
    github_actions_environment_variable.tfvars,
    github_actions_environment_variable.tfbackend,
    github_actions_environment_secret.subscription_id,
    github_actions_environment_secret.tenant_id,
    github_actions_environment_secret.client_id,
    github_actions_environment_secret.state_rg,
    github_actions_environment_secret.state_st,
    azurerm_storage_container.this,
    azurerm_role_assignment.blob_owner,
    azurerm_role_assignment.contributor
  ]
}
resource "github_repository_file" "gitignore" {
  repository          = github_repository.this.name
  branch              = github_branch.main.branch
  file                = ".gitignore"
  content             = file("${path.module}/files/.gitignore")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}

resource "github_repository_file" "tflint" {
  repository          = github_repository.this.name
  branch              = github_branch.main.branch
  file                = ".tflint.hcl"
  content             = file("${path.module}/files/.tflint.hcl")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}

resource "github_repository_file" "vscode_settings" {
  repository          = github_repository.this.name
  branch              = github_branch.main.branch
  file                = ".vscode/settings.json"
  content             = file("${path.module}/files/vscode_settings.json")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}

resource "github_repository_file" "github_devcontainer" {
  repository          = github_repository.this.name
  branch              = github_branch.main.branch
  file                = ".github/devcontainer.json"
  content             = file("${path.module}/files/github_devcontainer.json")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}

resource "github_repository_file" "github_env_tfvars" {
  for_each = { for environment in local.environments : environment.name => environment }

  repository          = github_repository.this.name
  branch              = github_branch.main.branch
  file                = format("environments/%s.tfvars", each.value.name)
  content             = file("${path.module}/files/example.tfvars")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}

data "template_file" "env_tfbackend" {
  for_each = { for environment in local.environments : environment.name => environment }

  template = file("${path.module}/files/tfbackend.tftpl")
  vars = {
    rg_name  = local.rg_name
    st_name  = local.st_name
    key_name = format("%s.tfstate", each.value.name)
  }
}

resource "github_repository_file" "github_env_tfbackend" {
  for_each = { for environment in local.environments : environment.name => environment }

  repository          = github_repository.this.name
  branch              = github_branch.main.branch
  file                = format("environments/%s.tfbackend", each.value.name)
  content             = data.template_file.env_tfbackend[each.value.name].rendered
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}


resource "github_repository_file" "github_tf_files" {
  for_each = toset(local.tf_files)

  repository          = github_repository.this.name
  branch              = github_branch.main.branch
  file                = each.key
  content             = file("${path.module}/files/${each.key}")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}

resource "github_repository_file" "github_wf_files" {
  for_each = toset(local.wf_files)

  repository          = github_repository.this.name
  branch              = github_branch.main.branch
  file                = format(".github/workflows/%s", each.key)
  content             = file("${path.module}/files/workflow_${each.key}")
  commit_message      = "Managed by Terraform"
  commit_author       = var.commit_user.name
  commit_email        = var.commit_user.email
  overwrite_on_create = true
}
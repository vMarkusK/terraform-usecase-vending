
resource "github_repository" "this" {
  name = local.repository_name

  visibility             = "public"
  delete_branch_on_merge = false
  auto_init              = true
}

resource "github_branch" "main" {
  repository = github_repository.this.name
  branch     = "main"
}

resource "github_branch_default" "default" {
  repository = github_repository.this.name
  branch     = github_branch.main.branch
}

resource "github_actions_variable" "application_name" {
  repository    = github_repository.this.name
  variable_name = "APPLICATION_NAME"
  value         = var.usecase

  depends_on = [github_branch_default.default]
}
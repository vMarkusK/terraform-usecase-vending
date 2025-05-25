
resource "github_repository" "this" {
  name = local.repository_name

  visibility             = "public"
  delete_branch_on_merge = false
  auto_init              = true
}

resource "github_actions_variable" "application_name" {
  repository    = github_repository.this.name
  variable_name = "APPLICATION_NAME"
  value         = var.usecase
}
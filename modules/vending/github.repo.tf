#trivy:ignore:avd-gi-0001
resource "github_repository" "this" {
  name = local.repository_name

  visibility             = "public"
  vulnerability_alerts   = true
  delete_branch_on_merge = false
  auto_init              = true
}

resource "github_actions_variable" "application_name" {
  repository    = github_repository.this.name
  variable_name = "APPLICATION_NAME"
  value         = var.usecase
}

resource "github_repository_ruleset" "this" {
  name        = "protect-branch"
  repository  = github_repository.this.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    pull_request {
    }
  }

  depends_on = [
    github_repository_file.gitignore,
    github_repository_file.tflint,
    github_repository_file.trivy,
    github_repository_file.vscode_settings,
    github_repository_file.github_settings,
    github_repository_file.github_env_tfvars,
    github_repository_file.github_env_tfbackend,
    github_repository_file.github_tf_files,
    github_repository_file.github_wf_files
  ]

  lifecycle {
    replace_triggered_by = [
      github_repository_file.gitignore,
      github_repository_file.tflint,
      github_repository_file.trivy,
      github_repository_file.vscode_settings,
      github_repository_file.github_settings,
      github_repository_file.github_env_tfvars,
      github_repository_file.github_env_tfbackend,
      github_repository_file.github_tf_files,
      github_repository_file.github_wf_files
    ]
  }

}
output "github_repository_name" {
  description = "The name of the GitHub repository created for the usecase"
  value       = github_repository.this.name
}

output "github_repository_oidc_subject_claim_customization_template" {
  description = "The OIDC subject claim customization template for the GitHub repository created for the usecase"
  value       = data.github_actions_repository_oidc_subject_claim_customization_template.this
}
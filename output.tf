output "github_repository_oidc_subject_claim_customization_template" {
  description = "The OIDC subject claim customization template for each GitHub repository, keyed by usecase"
  value = {
    for usecase, module in module.usecases :
    usecase => module.github_repository_oidc_subject_claim_customization_template
  }
}
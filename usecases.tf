module "usecases" {
  for_each = { for usecase in var.usecases : usecase.usecase => usecase }

  source = "./modules/vending"

  subscription_id     = var.subscription_id
  usecase             = each.value.usecase
  github_organization = each.value.github_organization
  commit_user         = each.value.commit_user
  location            = each.value.location
}
variable "subscription_id" {
  description = "Subscription ID for all resources"
  type        = string
}

variable "location" {
  description = "Location for all resources"
  type        = string
}

variable "usecase" {
  description = "UseCase Shortname"
  type        = string
  validation {
    condition     = can(regex("^[a-z]{1,8}$", var.usecase))
    error_message = "The usecase value must be lowercase letters only and maximum 8 characters long."
  }
}

variable "github_organization" {
  description = "GitHub organization name"
  type        = string
}

variable "commit_user" {
  type = object({
    name  = string
    email = string
  })
  description = <<DESCRIPTION
The GitHub identity used to commit the workflow YAML file to the repository.

This includes:
- **name**: The name of the user committing the workflow file.
- **email**: The email address of the user committing the workflow file.

Ensure that the provided Git identity has the necessary permissions to push changes to the specified repository and branch.
DESCRIPTION
}
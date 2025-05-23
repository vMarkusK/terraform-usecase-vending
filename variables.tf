variable "subscription_id" {
  description = "Subscription ID for all resources"
  type        = string
}

variable "usecases" {
  description = "Object for usecases"
  type = list(object({
    usecase             = string
    github_organization = string
    commit_user = object({
      name  = string
      email = string
    })
    location = optional(string, "germanywestcentral")
  }))
}
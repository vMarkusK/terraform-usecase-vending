variable "subscription_id" {
  description = "Subscription ID for all resources"
  type        = string
}

variable "location" {
  description = "Location for all resources"
  type        = string
  default     = "germywestcentral"
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
  default     = "vMarkusK"
}
# General
variable "subscription_id" {
  description = "Subscription ID for all resources"
  type        = string
}

variable "location" {
  description = "Location for all resources"
  type        = string
  default     = "germanywestcentral"
}

variable "env" {
  description = "Environment Name"
  type        = string
}

variable "usecase" {
  description = "Use Case Name"
  type        = string
}

variable "suffix" {
  description = "Use Case Suffix"
  type        = string
}
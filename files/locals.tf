# Naming
locals {
  rg_name = format("rg-%s-%s-%s", var.env, var.usecase, var.suffix)
}
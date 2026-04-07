variable "subscription_id" {}
variable "tenant_id" {}

variable "environment" {}
variable "location" {}

variable "resource_group_name" {
  default = "rg-funcproject-dev"
}

variable "dotnet_version" {
  default = "6.0"
}

# Managed Identity
variable "user_identity_name" {
  default = "func-identity"
}

# MAIN MAP
variable "app_name_list" {
  type = map(object({
    func_app_name         = string
    storage_account_name  = string
    app_service_plan_name = string
    runtime               = string
  }))
}
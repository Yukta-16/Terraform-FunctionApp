variable "app_name_list" {
  type = map(object({
    func_app_name         = string
    storage_account_name  = string
    app_service_plan_name = string
    runtime               = string
  }))
}

variable "location" {}
variable "resource_group_name" {}
variable "environment" {}
variable "dotnet_version" {}

variable "identity_id" {}
variable "principal_id" {}

variable "tags" {
  type = map(string)
}
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

variable "subnet_id" {}
variable "blob_dns_id" {}
variable "function_dns_id" {}

variable "keyvault_name" {}

variable "queue_dns_id" {}

variable "table_dns_id" {}

variable "file_dns_id" {}

variable "tags" {
  type = map(string)
}
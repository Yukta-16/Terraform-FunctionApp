variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "dotnet_version" {
  type    = string
  default = "6"
}

variable "user_identity_name" {
  type = string
}
ariable "identity_id" {
  type = string
}

variable "principal_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "blob_dns_id" {
  type = string
}

variable "queue_dns_id" {
  type = string
}

variable "table_dns_id" {
  type = string
}

variable "file_dns_id" {
  type = string
}

variable "function_dns_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "app_name_list" {
  type = map(object({
    func_app_name         = string
    storage_account_name  = string
    app_service_plan_name = string
    runtime               = string
  }))
}
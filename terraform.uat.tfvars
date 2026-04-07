location            = "Central India"
resource_group_name = "rg-funcproject-uat"
environment         = "uat"

user_identity_name = "funci-contoso-uat"

identity_id  = "xxxxxxx"
principal_id = "xxxxxxxx"

subnet_id = "xxxxxx"

blob_dns_id     = "/subscriptions/xxxx/.../privateDnsZones/privatelink.blob.core.windows.net"
queue_dns_id    = "/subscriptions/xxxx/.../privatelink.queue.core.windows.net"
table_dns_id    = "/subscriptions/xxxx/.../privatelink.table.core.windows.net"
file_dns_id     = "/subscriptions/xxxx/.../privatelink.file.core.windows.net"
function_dns_id = "/subscriptions/xxxx/.../privatelink.azurewebsites.net"

app_name_list = {

  python_app1 = {
    func_app_name         = "performance"
    storage_account_name  = "stguatperformance"
    app_service_plan_name = "asp-common-uat"
    runtime               = "python"
    python_version        = "3.10"
  }

  python_app2 = {
    func_app_name         = "email"
    storage_account_name  = "stguatemail"
    app_service_plan_name = "asp-common-uat"
    runtime               = "python"
    python_version        = "3.10"

  }

  dotnet_app1 = {
    func_app_name         = "verification"
    storage_account_name  = "stguatverification"
    app_service_plan_name = "asp-common-uat"
    runtime               = "dotnet"
  }
}
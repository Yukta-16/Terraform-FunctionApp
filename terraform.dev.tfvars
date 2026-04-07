location            = "Central India"
resource_group_name = "rg-funcproject-dev"
environment         = "dev"

user_identity_name = "funci-contoso-dev"

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
    storage_account_name  = "stgdevperformance"
    app_service_plan_name = "asp-common-dev"
    runtime               = "python"
    python_version        = "3.10"
  }

  python_app2 = {
    func_app_name         = "email"
    storage_account_name  = "stgdevemail"
    app_service_plan_name = "asp-common-dev"
    runtime               = "python"
    python_version        = "3.10"

  }

  dotnet_app1 = {
    func_app_name         = "verification"
    storage_account_name  = "stgdevverification"
    app_service_plan_name = "asp-common-dev"
    runtime               = "dotnet"
  }
}
#Log Analytics
resource "azurerm_log_analytics_workspace" "log" {
  for_each = var.app_name_list

  name                = "log-${each.value.func_app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"

  tags = var.tags
}

#App Insights
resource "azurerm_application_insights" "appi" {
  for_each = var.app_name_list

  name                = "appi-${each.value.func_app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.log[each.key].id
  application_type    = "web"

  tags = var.tags
}

#Storage Account
resource "azurerm_storage_account" "stg" {
  for_each = var.app_name_list

  name                     = lower(replace("st${each.value.storage_account_name}${var.environment}", "-", ""))
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

#blob Private Endpoint

resource "azurerm_private_endpoint" "storage_pe" {
  for_each = var.app_name_list

  name                = "pe-stg-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
 
  private_service_connection {
    name                           = "psc-stg-${each.key}"
    private_connection_resource_id = azurerm_storage_account.stg[each.key].id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "blob-zone"
    private_dns_zone_ids = [var.blob_dns_id]
  }
}

#Queue Endpoints
resource "azurerm_private_endpoint" "queue_pe" {
  for_each = var.app_name_list

  name                = "pe-queue-${each.key}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-queue-${each.key}"
    private_connection_resource_id = azurerm_storage_account.stg[each.key].id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "queue-dns-${each.key}"
    private_dns_zone_ids = [var.queue_dns_id]
  }

  depends_on = [azurerm_storage_account.stg]
}

#table Private Endpoints
resource "azurerm_private_endpoint" "table_pe" {
  for_each = var.app_name_list

  name                = "pe-table-${each.key}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-table-${each.key}"
    private_connection_resource_id = azurerm_storage_account.stg[each.key].id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "table-dns-${each.key}"
    private_dns_zone_ids = [var.table_dns_id]
  }

  depends_on = [azurerm_storage_account.stg]
}

#File Private Endpoints
resource "azurerm_private_endpoint" "file_pe" {
  for_each = var.app_name_list

  name                = "pe-file-${each.key}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-file-${each.key}"
    private_connection_resource_id = azurerm_storage_account.stg[each.key].id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "file-dns-${each.key}"
    private_dns_zone_ids = [var.file_dns_id]
  }

  depends_on = [azurerm_storage_account.stg]
}

#Existing App Service Plan
data "azurerm_service_plan" "plan" {
  for_each = var.app_name_list

  name                = each.value.app_service_plan_name
  resource_group_name = var.resource_group_name
}

#Function App
resource "azurerm_windows_function_app" "func" {
  for_each = var.app_name_list

  name                = "func-${each.value.func_app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = data.azurerm_service_plan.plan[each.key].id

  storage_account_name       = azurerm_storage_account.stg[each.key].name
  storage_account_access_key = azurerm_storage_account.stg[each.key].primary_access_key

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  site_config {
    application_stack {
      dotnet_version   = each.value.runtime == "dotnet" ? (contains(keys(each.value), "dotnet_version") && each.value.dotnet_version != null ? each.value.dotnet_version : var.dotnet_version) : null
      python_version = each.value.runtime == "python" ? (contains(keys(each.value), "python_version") && each.value.python_version != null ? each.value.python_version : var.python_version) : null
    }
}

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = each.value.runtime
    APPINSIGHTS_KEY          = azurerm_application_insights.appi[each.key].instrumentation_key
    KEY_VAULT_URI            = azurerm_key_vault.kv.vault_uri
  }

  tags = var.tags
}


#Function Private Endpoint
resource "azurerm_private_endpoint" "func_pe" {
  for_each = var.app_name_list

  name                = "pe-func-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-func-${each.key}"
    private_connection_resource_id = azurerm_windows_function_app.func[each.key].id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "func-zone"
    private_dns_zone_ids = [var.function_dns_id]
  }
}

#RBAC
resource "azurerm_role_assignment" "rbac" {
  for_each = var.app_name_list

  scope                = azurerm_storage_account.stg[each.key].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.principal_id
}


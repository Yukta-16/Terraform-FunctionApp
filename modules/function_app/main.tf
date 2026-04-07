# Log Analytics
resource "azurerm_log_analytics_workspace" "log" {
  for_each = var.app_name_list

  name                = "log-${each.value.func_app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"

  tags = var.tags
}

# App Insights
resource "azurerm_application_insights" "appi" {
  for_each = var.app_name_list

  name                = "appi-${each.value.func_app_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.log[each.key].id
  application_type    = "web"

  tags = var.tags
}

# Storage Account
resource "azurerm_storage_account" "stg" {
  for_each = var.app_name_list

  name                     = lower(replace("st${each.value.storage_account_name}${var.environment}", "-", ""))
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

# Existing App Service Plan
data "azurerm_service_plan" "plan" {
  for_each = var.app_name_list

  name                = each.value.app_service_plan_name
  resource_group_name = var.resource_group_name
}

# Function App
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

  dynamic "application_stack" {
    for_each = each.value.runtime == "dotnet" ? [1] : []

    content {
      dotnet_version = "6"
    }
  }

}


  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = each.value.runtime
    APPINSIGHTS_KEY          = azurerm_application_insights.appi[each.key].instrumentation_key
    #KEY_VAULT_URI = azurerm_key_vault.kv.vault_uri
  }

  tags = var.tags
}

# RBAC
resource "azurerm_role_assignment" "rbac" {
  for_each = var.app_name_list

  scope                = azurerm_storage_account.stg[each.key].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.principal_id
}


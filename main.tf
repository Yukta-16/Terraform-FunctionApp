# ManagedIdentity Creation
resource "azurerm_user_assigned_identity" "identity" {
  name                = var.user_identity_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "function_app" {
  source = "./modules/function_app"

  app_name_list       = var.app_name_list
  location            = var.location
  resource_group_name = var.resource_group_name
  environment         = var.environment
  dotnet_version      = var.dotnet_version
  
  identity_id  = azurerm_user_assigned_identity.identity.id
  principal_id = azurerm_user_assigned_identity.identity.principal_id

  subnet_id        = var.subnet_id
  blob_dns_id      = var.blob_dns_id
  queue_dns_id     = var.queue_dns_id
  table_dns_id     = var.table_dns_id
  file_dns_id      = var.file_dns_id
  function_dns_id  = var.function_dns_id

  tags = local.common_tags
}
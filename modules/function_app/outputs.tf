output "function_app_names" {
  value = {
    for k, v in azurerm_windows_function_app.func :
    k => v.name
  }
}
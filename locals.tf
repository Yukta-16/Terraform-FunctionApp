locals {
  common_tags = {
    project     = "terraform-function-app"
    region      = "cin"
    environment = var.environment
    owner       = "Yukta Thakur"
  }
}
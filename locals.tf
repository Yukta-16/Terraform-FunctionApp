locals {
  common_tags = {
    project     = "terraform-function-app"
    environment = var.environment
    owner       = "Yukta Thakur"
  }
}
resource "random_string" "suffix" {
  length  = 4
  special = false
  lower   = true
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.LAB}-${lower(replace(var.EMAIL,"/\\W|_|\\s/","-"))}"
  location = "EastAsia"
  tags = {
    email = "${var.EMAIL}"
  }
}

resource "random_password" "login_password" {
  length           = 50
  special          = true
  override_special = "!@#$%&"
}

resource "azurerm_container_group" "bastion" {
  name                = "${var.LAB}-${random_string.suffix.result}-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "public"
  os_type             = "Linux"

  container {
    name   = "ssh-tunneling-bastion"
    image  = "wongcyrus/ssh-tunneling-bastion:v1"
    cpu    = "1"
    memory = "1"
    environment_variables = {
      "BASTION_PASSWORD" = random_password.login_password.result
      "STUDENT_PASSWORD" = random_password.login_password.result
    }
    ports {
      port     = 22
      protocol = "TCP"
    }
  }
}
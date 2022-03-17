resource "random_string" "suffix" {
  length  = 4
  special = false
  lower   = true
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.LAB}-${lower(replace(var.EMAIL, "/\\W|_|\\s/", "-"))}"
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

  image_registry_credential {
    username = var.BASTION_ARC_ADMIN_USERNAME
    password = var.BASTION_ARC_ADMIN_PASSWORD
    server   = var.BASTION_ARC_LOGIN_SERVER
  }
  container {
    name   = "ssh-tunneling-bastion"
    image  = "${var.BASTION_ARC_LOGIN_SERVER}/ssh-tunneling-bastion"
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
resource "random_string" "suffix" {
  length  = 4
  special = false
  lower   = true
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.LAB}-${random_string.suffix.result}"
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

resource "azurerm_container_registry" "acr" {
  name                = "${random_string.suffix.result}BastionContainerRegistry"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_container_registry_task" "build_bastion_image_task" {
  name                  = "build_bastion_image_task"
  container_registry_id = azurerm_container_registry.acr.id
  platform {
    os = "Linux"
  }
  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = "https://github.com/wongcyrus/ssh-tunneling-bastion#main"
    context_access_token = "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"
    image_names          = ["ssh-tunneling-bastion:latest"]
    arguments = {
      AZURE_CLI_VERSION = "2.32.0"
      TERRAFORM_VERSION = "1.1.4"
    }
  }
}

data "http" "docker_file" {
  url = "https://raw.githubusercontent.com/wongcyrus/ssh-tunneling-bastion/master/Dockerfile"
}

resource "null_resource" "run_arc_task" {
  provisioner "local-exec" {
    command = "az acr task run --registry ${azurerm_container_registry.acr.name} --name build_bastion_image_task"
  }
  depends_on = [azurerm_container_registry_task.build_bastion_image_task]
  triggers = {
    dockerfile = data.http.docker_file.body
  }
}

resource "azurerm_container_group" "bastion" {
  depends_on = [
    null_resource.run_arc_task
  ]
  name                = "${var.LAB}-${random_string.suffix.result}-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "public"
  os_type             = "Linux"

  image_registry_credential {
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
    server   = azurerm_container_registry.acr.login_server
  }
  container {
    name   = "ssh-tunneling-bastion"
    image  = "${azurerm_container_registry.acr.login_server}/ssh-tunneling-bastion"
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
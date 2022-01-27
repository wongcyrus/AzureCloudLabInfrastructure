resource "random_string" "suffix" {
  length  = 4
  special = false
  lower   = true
  upper   = false
}

resource "azurerm_resource_group" "example" {
  name     = "${var.NAME}-${var.STUDENT_ID}-${random_string.suffix.result}" 
  location = "EastAsia"
}

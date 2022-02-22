output "EMAIL" {
  value       = var.EMAIL
  description = "Student Email"
}

output "LAB" {
  value       = var.LAB
  description = "LAB"
}

output "IpAddress" {
  value = azurerm_container_group.bastion.ip_address
}

output "Port" {
  value = 22
}

output "Username" {
  value = "bastion"
}

output "Password" {
  value     = nonsensitive(random_password.login_password.result)
  sensitive = false
}




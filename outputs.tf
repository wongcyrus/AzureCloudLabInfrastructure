output "EMAIL" {
  value       = var.EMAIL
  description = "Student Email"
}

output "LAB" {
  value       = var.LAB
  description = "LAB"
}

output "login_username" {
  value = "student"
}
output "login_password" {
  value = random_string.login_password.result
}

output "bastion_ip" {
  value = azurerm_container_group.bastion.ip_address
}



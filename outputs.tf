output "EMAIL" {
  value       = var.EMAIL
  description = "Student Email"
}

output "LAB" {
  value       = var.LAB
  description = "LAB"
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Resource Group Name"
}

output "rdp_connection_string" {
  value = "mstsc.exe /v:${azurerm_public_ip.public_ip.ip_address}:3389"
}

output "vm_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "login_username" {
  value = azurerm_windows_virtual_machine.vm.admin_username
}
output "login_password" {
  value = random_string.winpassword.result
}



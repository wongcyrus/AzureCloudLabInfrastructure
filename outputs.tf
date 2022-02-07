output "EMAIL" {
  value       = var.EMAIL
  description = "Student Email"
}

output "LAB" {
  value       = var.LAB
  description = "LAB"
}


output "resource_group_name" {
  value       = azurerm_resource_group.example.name
  description = "Resource Group Name"
}




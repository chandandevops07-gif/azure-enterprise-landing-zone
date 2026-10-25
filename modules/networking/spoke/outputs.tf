output "spoke_vnet_id" {
  description = "The ID of the Spoke Virtual Network."
  value       = azurerm_virtual_network.spoke.id
}

output "spoke_vnet_name" {
  description = "The name of the Spoke Virtual Network."
  value       = azurerm_virtual_network.spoke.name
}

output "pe_subnet_id" {
  description = "The ID of the Private Endpoint Subnet."
  value       = azurerm_subnet.pe_subnet.id
}

output "compute_subnet_id" {
  description = "The ID of the Compute Workload Subnet."
  value       = azurerm_subnet.compute_subnet.id
}

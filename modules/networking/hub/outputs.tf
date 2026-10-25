output "hub_vnet_id" {
  description = "The ID of the Hub Virtual Network."
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "The name of the Hub Virtual Network."
  value       = azurerm_virtual_network.hub.name
}

output "firewall_private_ip" {
  description = "Private IP of the Azure Firewall used as next-hop in UDRs."
  value       = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
}

output "private_dns_zone_openai_id" {
  description = "Resource ID of the privatelink.openai.azure.com DNS Zone."
  value       = azurerm_private_dns_zone.openai.id
}

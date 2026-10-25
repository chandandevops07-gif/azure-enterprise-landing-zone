output "openai_id" {
  description = "The ID of the Azure OpenAI Service."
  value       = azurerm_cognitive_account.openai.id
}

output "openai_endpoint" {
  description = "The private endpoint URL of the Azure OpenAI Service."
  value       = azurerm_cognitive_account.openai.endpoint
}

output "private_endpoint_id" {
  description = "The Resource ID of the Azure Private Endpoint."
  value       = azurerm_private_endpoint.openai_pe.id
}

output "private_ip_address" {
  description = "The private IP address assigned to the Azure OpenAI Private Endpoint."
  value       = azurerm_private_endpoint.openai_pe.private_service_connection[0].private_ip_address
}

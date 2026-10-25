# Terraform Module: Azure AI / GenAI Landing Zone
# Implements Enterprise-grade Azure OpenAI, Private Endpoints, and Cognitive Services

resource "azurerm_cognitive_account" "openai" {
  name                          = var.openai_account_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = false
  custom_subdomain_name         = var.custom_subdomain_name

  network_acls {
    default_action = "Deny"
    ip_rules       = []
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Deploy GPT-4o Model Deployment
resource "azurerm_cognitive_deployment" "gpt4o" {
  name                 = var.deployment_name
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = "gpt-4o"
    version = "2024-05-13"
  }

  scale {
    type     = "Standard"
    capacity = var.model_capacity_tpm
  }
}

# Deploy Text Embedding Model for Vector Search / RAG
resource "azurerm_cognitive_deployment" "embedding" {
  name                 = "text-embedding-3-large"
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = "text-embedding-3-large"
    version = "1"
  }

  scale {
    type     = "Standard"
    capacity = 100
  }
}

# Azure Private Endpoint for Azure OpenAI
resource "azurerm_private_endpoint" "openai_pe" {
  name                = "${var.openai_account_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.openai_account_name}-psc"
    private_connection_resource_id = azurerm_cognitive_account.openai.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "openai-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_openai_id]
  }

  tags = var.tags
}

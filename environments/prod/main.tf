# Production Environment Orchestration
# Demonstrates end-to-end deployment of Hub, Spoke, and Azure AI Landing Zone

terraform {
  required_version = ">= 1.8.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-mgmt-prod"
    storage_account_name = "sttfstateenterpriseprod"
    container_name       = "tfstate"
    key                  = "prod.enterprise.landingzone.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    cognitive_account {
      purge_soft_delete_on_destroy = false
    }
  }
}

# 1. Resource Groups
resource "azurerm_resource_group" "hub_rg" {
  name     = "rg-connectivity-hub-prod"
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_resource_group" "spoke_ai_rg" {
  name     = "rg-workload-ai-prod"
  location = var.location
  tags     = var.common_tags
}

# 2. Central Hub Network Module
module "hub_network" {
  source                 = "../../modules/networking/hub"
  hub_vnet_name          = "vnet-hub-core-prod"
  location               = var.location
  resource_group_name    = azurerm_resource_group.hub_rg.name
  hub_address_space      = "10.0.0.0/16"
  firewall_subnet_prefix = "10.0.1.0/26"
  gateway_subnet_prefix  = "10.0.2.0/27"
  bastion_subnet_prefix  = "10.0.3.0/26"
  tags                   = var.common_tags
}

# 3. Spoke Network Module (Enterprise AI Workload)
module "spoke_ai_network" {
  source                  = "../../modules/networking/spoke"
  spoke_vnet_name         = "vnet-spoke-genai-prod"
  location                = var.location
  resource_group_name     = azurerm_resource_group.spoke_ai_rg.name
  spoke_address_space     = "10.10.0.0/20"
  pe_subnet_prefix        = "10.10.1.0/24"
  compute_subnet_prefix   = "10.10.2.0/24"
  hub_vnet_id             = module.hub_network.hub_vnet_id
  hub_vnet_name           = module.hub_network.hub_vnet_name
  hub_resource_group_name = azurerm_resource_group.hub_rg.name
  hub_firewall_private_ip = module.hub_network.firewall_private_ip
  tags                    = var.common_tags
}

# 4. Enterprise Azure AI / GenAI Landing Zone Module
module "azure_ai_landing_zone" {
  source                     = "../../modules/ai_landing_zone"
  openai_account_name        = "aoai-core-prod-001"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.spoke_ai_rg.name
  custom_subdomain_name      = "aoai-enterprise-core-prod"
  deployment_name            = "gpt-4o"
  model_capacity_tpm         = 120
  private_endpoint_subnet_id = module.spoke_ai_network.pe_subnet_id
  private_dns_zone_openai_id = module.hub_network.private_dns_zone_openai_id
  tags                       = var.common_tags
}

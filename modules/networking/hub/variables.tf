variable "hub_vnet_name" {
  type        = string
  description = "Name of the Central Hub Virtual Network."
  default     = "vnet-hub-core-prod"
}

variable "location" {
  type        = string
  description = "Azure Region for Hub."
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group for Hub Network."
}

variable "hub_address_space" {
  type        = string
  description = "Address prefix for Hub VNet (e.g., 10.0.0.0/16)."
  default     = "10.0.0.0/16"
}

variable "firewall_subnet_prefix" {
  type        = string
  description = "Subnet prefix for AzureFirewallSubnet (min /26)."
  default     = "10.0.1.0/26"
}

variable "gateway_subnet_prefix" {
  type        = string
  description = "Subnet prefix for GatewaySubnet (min /27)."
  default     = "10.0.2.0/27"
}

variable "bastion_subnet_prefix" {
  type        = string
  description = "Subnet prefix for AzureBastionSubnet (min /26)."
  default     = "10.0.3.0/26"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all Hub resources."
  default     = {}
}

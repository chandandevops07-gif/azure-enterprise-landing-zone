variable "spoke_vnet_name" {
  type        = string
  description = "Name of the Spoke Virtual Network."
}

variable "location" {
  type        = string
  description = "Azure Region for Spoke."
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group for Spoke Network."
}

variable "spoke_address_space" {
  type        = string
  description = "Address prefix for Spoke VNet (e.g., 10.10.0.0/20)."
}

variable "pe_subnet_prefix" {
  type        = string
  description = "Subnet prefix for Private Endpoints."
}

variable "compute_subnet_prefix" {
  type        = string
  description = "Subnet prefix for Compute Workloads."
}

variable "hub_vnet_id" {
  type        = string
  description = "Resource ID of the Hub VNet."
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the Hub VNet."
}

variable "hub_resource_group_name" {
  type        = string
  description = "Resource Group where Hub VNet resides."
}

variable "hub_firewall_private_ip" {
  type        = string
  description = "Private IP of Hub Firewall for UDR 0.0.0.0/0 route."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all Spoke resources."
  default     = {}
}

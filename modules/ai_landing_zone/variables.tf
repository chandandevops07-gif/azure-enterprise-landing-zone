variable "openai_account_name" {
  type        = string
  description = "The name of the Azure OpenAI Cognitive Service account."
}

variable "location" {
  type        = string
  description = "Azure Region for deployment."
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group where OpenAI resources are hosted."
}

variable "custom_subdomain_name" {
  type        = string
  description = "Unique custom subdomain for private endpoint routing."
}

variable "deployment_name" {
  type        = string
  description = "Deployment name for the GPT model."
  default     = "gpt-4o"
}

variable "model_capacity_tpm" {
  type        = number
  description = "Tokens-per-minute throughput capacity in thousands."
  default     = 120
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet ID in the Spoke VNet dedicated to Private Endpoints."
}

variable "private_dns_zone_openai_id" {
  type        = string
  description = "Resource ID of the privatelink.openai.azure.com DNS Zone."
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all AI resources."
  default     = {}
}

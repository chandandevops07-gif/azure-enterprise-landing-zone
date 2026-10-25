variable "location" {
  type        = string
  description = "Target primary Azure Region."
  default     = "eastus"
}

variable "common_tags" {
  type        = map(string)
  description = "Mandatory FinOps and Governance tags."
  default = {
    Environment   = "Production"
    Owner         = "CloudArchitectureTeam"
    CostCenter    = "CC-1094-INFRA"
    ManagedBy     = "Terraform"
    Compliance    = "CIS-Azure-v2.0"
    BusinessUnit  = "EnterpriseAI"
  }
}

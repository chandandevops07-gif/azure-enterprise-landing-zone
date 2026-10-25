# Terraform Module: Spoke Virtual Network & Hub Peering with Route Table

resource "azurerm_virtual_network" "spoke" {
  name                = var.spoke_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.spoke_address_space]
  tags                = var.tags
}

# Subnet for AI Workloads / Private Endpoints
resource "azurerm_subnet" "pe_subnet" {
  name                 = "snet-private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.pe_subnet_prefix]
}

# Subnet for Workload Compute / Microservices
resource "azurerm_subnet" "compute_subnet" {
  name                 = "snet-workload-compute"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.compute_subnet_prefix]
}

# User Defined Route Table (Forced Tunneling via Hub Firewall)
resource "azurerm_route_table" "spoke_udr" {
  name                          = "${var.spoke_vnet_name}-udr"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = false

  route {
    name                   = "DefaultRouteToFirewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.hub_firewall_private_ip
  }

  tags = var.tags
}

# Associate UDR with Compute Subnet
resource "azurerm_subnet_route_table_association" "compute_assoc" {
  subnet_id      = azurerm_subnet.compute_subnet.id
  route_table_id = azurerm_route_table.spoke_udr.id
}

# Bi-directional Peering: Spoke -> Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "${var.spoke_vnet_name}-to-hub"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}

# Bi-directional Peering: Hub -> Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "hub-to-${var.spoke_vnet_name}"
  resource_group_name          = var.hub_resource_group_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

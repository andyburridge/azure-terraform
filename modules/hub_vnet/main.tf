# ----------------
# Module to create an Azure Hub VNET as part of a hub/spoke network with Gateway transit through the hub.
#
# Andrew Burridge - 01/2022
# ----------------


terraform {
    required_version = ">= 1.0.11"
}


# ----------------
#    Resources
# ----------------

resource "azurerm_resource_group" "network_hub_RG" {
  name     = var.rg_name
  location = var.resource_location
}

resource "azurerm_virtual_network" "network_hub_VNET" {
  name                = var.vnet_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.network_hub_RG.name
  address_space       = var.vnet_address_space

  dynamic "subnet" {
    for_each = var.subnet_config
    content {
      name           = subnet.value["subnet_name"]
      address_prefix = subnet.value["subnet_prefix"]
      #security_group = subnet_config.value.subnet_nsg
    }
  }

  tags = var.tags

  depends_on = [    
    azurerm_resource_group.network_hub_RG
  ]
}

resource "azurerm_virtual_network_peering" "network_hub_PEER" {
  for_each = {for peer in var.peering_config:  peer.name => peer}
    name                      = "${each.value.name}"
    resource_group_name       = "${each.value.resource_group_name}"
    virtual_network_name      = "${each.value.virtual_network_name}"
    remote_virtual_network_id = "${each.value.remote_virtual_network_id}"
    allow_gateway_transit     = "${each.value.allow_gateway_transit}"
    use_remote_gateways       = "${each.value.use_remote_gateways}"
  
  depends_on = [    
    azurerm_resource_group.network_hub_RG,
    azurerm_virtual_network.network_hub_VNET,  
  ]
}

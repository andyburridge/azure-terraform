# ----------------
# Plan to create a Hub VNET for the 'techops' organsiation, with VNET Peerings
#
# Andrew Burridge - 01/2022
# ----------------

provider "azurerm" {
  features {}
}


# ----------------
#    Locals
# ----------------

# Base locals
locals {  
  resource_location  = "uksouth"
  environment        = "prod" 
  service_owner      = "techops"
  vnet_address_space = ["10.0.0.0/16"]
}

# Composite locals
locals {  
  resource_group_name  = "rg-${local.environment}-hub-${local.service_owner}-${local.resource_location}-001"
  vnet_name            = "vnet-${local.environment}-hub-${local.service_owner}-${local.resource_location}-001"
  subnet_config        = [
    {
      subnet_name   = "snet-${local.environment}-hub-${local.service_owner}-${local.resource_location}-001"
      subnet_prefix = "10.0.1.0/24"
      subnet_nsg    = "nsg-${local.environment}-hub-${local.service_owner}-${local.resource_location}-001"
    },
    {
      subnet_name   = "snet-${local.environment}-hub-${local.service_owner}-${local.resource_location}-002"
      subnet_prefix = "10.0.2.0/24"
      subnet_nsg    = "nsg-${local.environment}-hub-${local.service_owner}-${local.resource_location}-002"
    }
    ]
  tags = {
      environment = local.environment
      owner       = local.service_owner
  }
  peering_config      = [
    {
      name                      = "peering-hub-${local.service_owner}-001-to-spoke-techops-001"
      resource_group_name       = "rg-${local.environment}-${local.service_owner}-hub-${local.resource_location}-001"
      virtual_network_name      = "vnet-${local.environment}-${local.service_owner}-hub-${local.resource_location}-001"
      remote_virtual_network_id = "/subscriptions/ee5a4125-f461-417d-ad27-a8204c7b4f21/resourceGroups/rg-prod-techops-spoke-uksouth-001/providers/Microsoft.Network/virtualNetworks/vnet-prod-techops-spoke-uksouth-001"
      allow_gateway_transit     = true
      use_remote_gateways       = false
    },
    {
      name                      = "peering-hub-${local.service_owner}-001-to-spoke-colleagueex-001"
      resource_group_name       = "rg-${local.environment}-${local.service_owner}-hub-${local.resource_location}-001"
      virtual_network_name      = "vnet-${local.environment}-${local.service_owner}-hub-${local.resource_location}-001"
      remote_virtual_network_id = "/subscriptions/ee5a4125-f461-417d-ad27-a8204c7b4f21/resourceGroups/rg-prod-colleagueex-spoke-uksouth-001/providers/Microsoft.Network/virtualNetworks/vnet-prod-colleagueex-spoke-uksouth-001"
      allow_gateway_transit     = true
      use_remote_gateways       = false
    }
    ]
}


# ----------------
#    Modules
# ----------------

module "techops_hub" {
    source             = "../../modules/hub_vnet"
    resource_location  = local.resource_location
    rg_name            = local.resource_group_name
    vnet_name          = local.vnet_name
    vnet_address_space = local.vnet_address_space
    subnet_config      = local.subnet_config
    tags               = local.tags
    peering_config     = local.peering_config
}


# ----------------
#    Outputs
# ----------------

output "hub_vnet_name" {
     value = module.techops_hub.vnet_name
}

output "hub_vnet_id" {
     value = module.techops_hub.vnet_id
}


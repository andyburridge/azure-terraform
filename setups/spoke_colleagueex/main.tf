# ----------------
# Plan to create a Spoke VNET for the 'colleague experience' organisation, VNET Peered to the Hub VNET with Gateway Transit enabled.
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
  service_owner      = "colleagueex"
  vnet_address_space = ["10.2.0.0/16"]
}

# Composite locals
locals {  
  resource_group_name  = "rg-${local.environment}-spoke-${local.service_owner}-${local.resource_location}-001"
  vnet_name            = "vnet-${local.environment}-spoke-${local.service_owner}-${local.resource_location}-001"
  subnet_config        = [
    {
      subnet_name   = "snet-${local.environment}-spoke-${local.service_owner}-${local.resource_location}-001"
      subnet_prefix = "10.2.1.0/24"
      subnet_nsg    = "nsg-${local.environment}-spoke-${local.service_owner}-${local.resource_location}-001"
    },
    {
      subnet_name   = "snet-${local.environment}-spoke-${local.service_owner}-${local.resource_location}-002"
      subnet_prefix = "10.2.2.0/24"
      subnet_nsg    = "nsg-${local.environment}-spoke-${local.service_owner}-${local.resource_location}-002"
    }
  ]
  tags = {
      environment = local.environment
      owner       = local.service_owner
  }
  peering_config    = [
    {
      name                      = "peering-spoke-${local.service_owner}-001-to-hub-techops-001"
      resource_group_name       = local.resource_group_name
      virtual_network_name      = local.vnet_name
      remote_virtual_network_id = "/subscriptions/ee5a4125-f461-417d-ad27-a8204c7b4f21/resourceGroups/rg-prod-techops-hub-uksouth-001/providers/Microsoft.Network/virtualNetworks/vnet-prod-techops-hub-uksouth-001"
      allow_gateway_transit     = true
      use_remote_gateways       = false
    }
  ]
}


# ----------------
#    Modules
# ----------------

module "techops_spoke" {
    source             = "../../modules/spoke_vnet"
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

output "spoke_vnet_name" {
     value = module.techops_spoke.vnet_name
}

output "spoke_vnet_id" {
     value = module.techops_spoke.vnet_id
}


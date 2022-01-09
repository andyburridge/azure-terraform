# ----------------
# Output file associated with Spoke VNET module.
#
# Andrew Burridge - 01/2022
# ----------------


output "vnet_name" {
    value = azurerm_virtual_network.network_spoke_VNET.name
}

output "vnet_id" {
    value = azurerm_virtual_network.network_spoke_VNET.id
}



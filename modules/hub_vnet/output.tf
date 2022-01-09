# ----------------
# Output file associated with Hub VNET module.
#
# Andrew Burridge - 01/2022
# ----------------


output "vnet_name" {
    value = azurerm_virtual_network.network_hub_VNET.name
}
output "vnet_id" {
    value = azurerm_virtual_network.network_hub_VNET.id
}

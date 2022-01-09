# ----------------
# Variables file associated with Hub VNET module.
#
# Andrew Burridge - 01/2022
# ----------------


variable "resource_location" {
  type = string
  description   = "Location of the resource set."
}

variable "rg_name" {
  type = string
  description   = "Name of the Resource Group."
}

variable "vnet_name" {
  type = string
  description   = "Name of the VNET."
}

variable "vnet_address_space" {
  type = list
  description   = "Address space of the VNET."
}

variable "subnet_config" {
  type = list(map(string))
  description = "List of Subnets and associated configuration items."
}

variable "tags" {
  type = map(string)
  description = "List of Tags."
}

variable "peering_config" {
  type = list(map(string))
  description = "List of VNET Peers and associated configuration items."
}
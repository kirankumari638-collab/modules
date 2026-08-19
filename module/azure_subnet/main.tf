variable subnets{}
resource "azurerm_subnet""subnet"{
    for_each=var.subnets
    name=each.value.subnet_name
    resource_group_name="rg-modules"
    virtual_network_name="vnet_prod"
    address_prefixes=each.value.address_prefixes
}
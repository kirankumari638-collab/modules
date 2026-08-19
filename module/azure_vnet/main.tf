resource"azurerm_virtual_network""vnet"{
    name="vnet_prod"
    resource_group_name="rg-modules"
    address_space=["10.0.0.0/16"]
    location="central india"
}
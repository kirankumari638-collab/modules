 data "azurerm_subnet" "subnet"{
    for_each=var.virtual_machine
    name=each.value.subnet_name
    resource_group_name = "rg-modules"
    virtual_network_name = "vnet_prod"
}

data "azurerm_public_ip""pip"{
    for_each=var.virtual_machine
    name=each.value.public_ip_name
    resource_group_name="rg-modules"
}


resource "azurerm_network_interface" "nic"{
    for_each=var.virtual_machine
    name=each.value.nic_name
    resource_group_name ="rg-modules"
    location="central india"
     ip_configuration{
        name="internal"
        subnet_id=data.azurerm_subnet.subnet[each.key].id
        public_ip_address_id=data.azurerm_public_ip.pip[each.key].id
        private_ip_address_allocation="Dynamic"
     }
}

resource "azurerm_linux_virtual_machine" "vms"{
    for_each=var.virtual_machine
  name                = each.value.vm_name
  resource_group_name = "rg-modules"
  location            = "central india"
  size                = "Standard_D2s_v3"
  admin_username      = each.value.admin_username
  admin_password = each.value.admin_password
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  


  admin_ssh_key {
    username   = each.value.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

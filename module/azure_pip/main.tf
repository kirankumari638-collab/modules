variable public_ip{}
resource "azurerm_public_ip" "pip"{
   for_each=var.public_ip
   name=each.value.public_ip_name
   resource_group_name="rg-modules"
   location="central india"
   allocation_method = "Static"
}

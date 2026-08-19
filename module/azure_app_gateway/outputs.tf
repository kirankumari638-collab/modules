output "resource_group_name" {
  description = "The name of the Resource Group."
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "The location of the Resource Group."
  value       = azurerm_resource_group.rg.location
}

output "virtual_network_id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "virtual_network_name" {
  description = "The name of the Virtual Network."
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_id" {
  description = "The ID of the ApplicationGatewaySubnet."
  value       = azurerm_subnet.appgw_subnet.id
}

output "subnet_name" {
  description = "The name of the ApplicationGatewaySubnet."
  value       = azurerm_subnet.appgw_subnet.name
}

output "public_ip_id" {
  description = "The ID of the Static Standard Public IP."
  value       = azurerm_public_ip.appgw_pip.id
}

output "public_ip_address" {
  description = "The assigned Static Public IP address."
  value       = azurerm_public_ip.appgw_pip.ip_address
}

output "application_gateway_id" {
  description = "The ID of the Application Gateway."
  value       = azurerm_application_gateway.appgw.id
}

output "application_gateway_name" {
  description = "The name of the Application Gateway."
  value       = azurerm_application_gateway.appgw.name
}

output "backend_address_pool_id" {
  description = "The ID of the backend address pool."
  value       = azurerm_application_gateway.appgw.backend_address_pool[0].id
}

output "frontend_ip_configuration_id" {
  description = "The ID of the frontend IP configuration."
  value       = azurerm_application_gateway.appgw.frontend_ip_configuration[0].id
}

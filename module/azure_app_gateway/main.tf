locals {
  gateway_ip_config_name    = "${var.app_gateway_name}-gw-ip-config"
  frontend_ip_config_name   = "${var.app_gateway_name}-frontend-ip-config"
  frontend_port_http_name   = "${var.app_gateway_name}-frontend-port-http"
  frontend_port_https_name  = "${var.app_gateway_name}-frontend-port-https"
  backend_pool_name         = "${var.app_gateway_name}-backend-pool"
  http_setting_name         = "${var.app_gateway_name}-backend-http-setting"
  probe_name                = "${var.app_gateway_name}-health-probe"
  http_listener_name        = "${var.app_gateway_name}-http-listener"
  https_listener_name       = "${var.app_gateway_name}-https-listener"
  http_routing_rule_name    = "${var.app_gateway_name}-http-routing-rule"
  https_routing_rule_name   = "${var.app_gateway_name}-https-routing-rule"
  redirect_config_name      = "${var.app_gateway_name}-redirect-http-to-https"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Dedicated Subnet for Application Gateway
resource "azurerm_subnet" "appgw_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
}

# Standard Static Public IP
resource "azurerm_public_ip" "appgw_pip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Application Gateway Standard_v2
resource "azurerm_application_gateway" "appgw" {
  name                = var.app_gateway_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.enable_autoscale ? null : var.sku_capacity
  }

  dynamic "autoscale_configuration" {
    for_each = var.enable_autoscale ? [1] : []
    content {
      min_capacity = var.autoscale_min_capacity
      max_capacity = var.autoscale_max_capacity
    }
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_config_name
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  # Frontend Port 80 (HTTP)
  frontend_port {
    name = local.frontend_port_http_name
    port = 80
  }

  # Frontend Port 443 (HTTPS)
  frontend_port {
    name = local.frontend_port_https_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_config_name
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  # Backend Address Pool
  backend_address_pool {
    name         = local.backend_pool_name
    ip_addresses = length(var.backend_ip_addresses) > 0 ? var.backend_ip_addresses : null
    fqdns        = length(var.backend_fqdns) > 0 ? var.backend_fqdns : null
  }

  # Backend HTTP Settings
  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = var.cookie_based_affinity
    path                  = var.backend_path
    port                  = var.backend_port
    protocol              = var.backend_protocol
    request_timeout       = var.backend_request_timeout
    probe_name            = local.probe_name
  }

  # Custom Health Probe
  probe {
    name                                      = local.probe_name
    protocol                                  = var.probe_protocol
    path                                      = var.probe_path
    host                                      = var.probe_host != "" ? var.probe_host : null
    pick_host_name_from_backend_http_settings = var.probe_host == "" ? true : false
    interval                                  = var.probe_interval
    timeout                                   = var.probe_timeout
    unhealthy_threshold                       = var.probe_unhealthy_threshold

    match {
      status_code = ["200-399"]
    }
  }

  # Optional SSL Certificate configuration
  dynamic "ssl_certificate" {
    for_each = var.enable_ssl && var.ssl_certificate_name != "" ? [1] : []
    content {
      name                = var.ssl_certificate_name
      data                = var.ssl_certificate_data != "" ? var.ssl_certificate_data : null
      password            = var.ssl_certificate_password != "" ? var.ssl_certificate_password : null
      key_vault_secret_id = var.key_vault_secret_id != "" ? var.key_vault_secret_id : null
    }
  }

  # HTTP Listener (Port 80)
  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_config_name
    frontend_port_name             = local.frontend_port_http_name
    protocol                       = "Http"
  }

  # HTTPS Listener (Port 443)
  dynamic "http_listener" {
    for_each = var.enable_ssl ? [1] : []
    content {
      name                           = local.https_listener_name
      frontend_ip_configuration_name = local.frontend_ip_config_name
      frontend_port_name             = local.frontend_port_https_name
      protocol                       = "Https"
      ssl_certificate_name           = var.ssl_certificate_name
    }
  }

  # Redirect Configuration (HTTP to HTTPS)
  dynamic "redirect_configuration" {
    for_each = var.enable_ssl && var.enable_http_to_https_redirect ? [1] : []
    content {
      name                 = local.redirect_config_name
      redirect_type        = "Permanent"
      target_listener_name = local.https_listener_name
      include_path         = true
      include_query_string = true
    }
  }

  # Request Routing Rule for HTTP Listener (Priority 10)
  request_routing_rule {
    name                        = local.http_routing_rule_name
    rule_type                   = "Basic"
    priority                    = 10
    http_listener_name          = local.http_listener_name
    backend_address_pool_name   = (var.enable_ssl && var.enable_http_to_https_redirect) ? null : local.backend_pool_name
    backend_http_settings_name  = (var.enable_ssl && var.enable_http_to_https_redirect) ? null : local.http_setting_name
    redirect_configuration_name = (var.enable_ssl && var.enable_http_to_https_redirect) ? local.redirect_config_name : null
  }

  # Request Routing Rule for HTTPS Listener (Priority 20)
  dynamic "request_routing_rule" {
    for_each = var.enable_ssl ? [1] : []
    content {
      name                       = local.https_routing_rule_name
      rule_type                  = "Basic"
      priority                   = 20
      http_listener_name         = local.https_listener_name
      backend_address_pool_name  = local.backend_pool_name
      backend_http_settings_name = local.http_setting_name
    }
  }
}

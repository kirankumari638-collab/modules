variable "resource_group_name" {
  description = "The name of the Resource Group in which to create resources."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "The name of the Virtual Network."
  type        = string
  default     = "vnet-appgw-prod"
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "The name of the dedicated Application Gateway Subnet."
  type        = string
  default     = "ApplicationGatewaySubnet"
}

variable "subnet_address_prefix" {
  description = "The address prefix for the Application Gateway Subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "public_ip_name" {
  description = "The name of the Static Standard Public IP."
  type        = string
  default     = "pip-appgw-prod"
}

variable "app_gateway_name" {
  description = "The name of the Azure Application Gateway."
  type        = string
  default     = "appgw-standard-v2"
}

variable "sku_name" {
  description = "The SKU Name for Application Gateway."
  type        = string
  default     = "Standard_v2"
}

variable "sku_tier" {
  description = "The SKU Tier for Application Gateway."
  type        = string
  default     = "Standard_v2"
}

variable "sku_capacity" {
  description = "Fixed instance capacity when autoscale is disabled."
  type        = number
  default     = 2
}

variable "enable_autoscale" {
  description = "Enable autoscale configuration for Application Gateway Standard_v2."
  type        = bool
  default     = false
}

variable "autoscale_min_capacity" {
  description = "Minimum capacity for autoscaling (1 to 100)."
  type        = number
  default     = 2
}

variable "autoscale_max_capacity" {
  description = "Maximum capacity for autoscaling (2 to 125)."
  type        = number
  default     = 10
}

# Backend Pool & Settings
variable "backend_ip_addresses" {
  description = "List of IP addresses for the Backend Address Pool."
  type        = list(string)
  default     = []
}

variable "backend_fqdns" {
  description = "List of FQDNs for the Backend Address Pool."
  type        = list(string)
  default     = []
}

variable "backend_port" {
  description = "The port used by the HTTP backend settings."
  type        = number
  default     = 80
}

variable "backend_protocol" {
  description = "The protocol used by the HTTP backend settings (Http or Https)."
  type        = string
  default     = "Http"
}

variable "backend_path" {
  description = "The path prefix for backend HTTP settings."
  type        = string
  default     = "/"
}

variable "backend_request_timeout" {
  description = "Request timeout in seconds for backend settings."
  type        = number
  default     = 30
}

variable "cookie_based_affinity" {
  description = "Cookie-based affinity setting (Enabled or Disabled)."
  type        = string
  default     = "Disabled"
}

# Health Probe
variable "probe_path" {
  description = "Health probe request path."
  type        = string
  default     = "/healthz"
}

variable "probe_protocol" {
  description = "Protocol used by health probe (Http or Https)."
  type        = string
  default     = "Http"
}

variable "probe_interval" {
  description = "Probe interval in seconds."
  type        = number
  default     = 30
}

variable "probe_timeout" {
  description = "Probe timeout in seconds."
  type        = number
  default     = 30
}

variable "probe_unhealthy_threshold" {
  description = "Number of consecutive failed probes before backend is marked unhealthy."
  type        = number
  default     = 3
}

variable "probe_host" {
  description = "Host header for health probe. If empty, pick host name from backend HTTP settings."
  type        = string
  default     = ""
}

# SSL Certificate & HTTPS Listener
variable "enable_ssl" {
  description = "Enable HTTPS listener and SSL Certificate configuration."
  type        = bool
  default     = false
}

variable "ssl_certificate_name" {
  description = "The name of the SSL Certificate in Application Gateway."
  type        = string
  default     = ""
}

variable "ssl_certificate_data" {
  description = "Base64 encoded PFX certificate data."
  type        = string
  default     = ""
  sensitive   = true
}

variable "ssl_certificate_password" {
  description = "Password for the PFX certificate."
  type        = string
  default     = ""
  sensitive   = true
}

variable "key_vault_secret_id" {
  description = "Key Vault Secret ID (Secret Identifier) containing the SSL Certificate."
  type        = string
  default     = ""
}

# Redirect Configuration
variable "enable_http_to_https_redirect" {
  description = "Automatically redirect incoming HTTP traffic (Port 80) to HTTPS (Port 443)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# ☁️ Azure Infrastructure Terraform Modules 🚀

This repository contains modularized **Terraform Infrastructure as Code (IaC)** for deploying and managing Azure cloud resources using the `azurerm` provider. It follows industry best practices for modular architecture, resource reusability, and environment separation.

---

## 📁 Repository Structure 🗂️

```text
modules/
├── 🌐 environment/
│   └── 🧪 preprod/              # Pre-production environment deployment
│       ├── 📜 main.tf           # Module instantiation & dependency wiring
│       ├── ⚙️ provider.tf       # Terraform & azurerm provider configurations
│       ├── 📋 variable.tf       # Environment-level input variable definitions
│       └── 🔑 terraform.tfvars  # Environment-specific parameter values
└── 📦 module/                   # Reusable Azure Terraform modules
    ├── 🌐 azure_app_gateway/    # Azure Application Gateway module
    ├── 🔌 azure_pip/            # Azure Public IP module
    ├── 🏗️ azure_resource_gr/    # Azure Resource Group module
    ├── 🕸️ azure_subnet/         # Azure Subnet module
    ├── 🖥️ azure_vm/             # Azure Linux Virtual Machine module
    └── 🗺️ azure_vnet/           # Azure Virtual Network module
```

---

## 🧩 Modules Overview 📑

| Emoji | Module Name | Description | 🛠️ Managed Resources |
| :---: | :--- | :--- | :--- |
| 🏗️ | **`azure_resource_gr`** | Creates and manages Azure Resource Groups | `azurerm_resource_group` |
| 🗺️ | **`azure_vnet`** | Provisions Virtual Network infrastructure | `azurerm_virtual_network` |
| 🕸️ | **`azure_subnet`** | Configures subnets dynamically via map inputs | `azurerm_subnet` |
| 🔌 | **`azure_pip`** | Provisions static or dynamic Public IP addresses | `azurerm_public_ip` |
| 🖥️ | **`azure_vm`** | Provisions Linux VMs with NICs & SSH auth | `azurerm_linux_virtual_machine`, `azurerm_network_interface` |
| 🌐 | **`azure_app_gateway`** | Configures Application Gateway with routing, listeners & WAF | `azurerm_application_gateway` |

---

## ⚡ Getting Started 🎯

### 📋 Prerequisites

- 🏗️ **Terraform**: CLI version `>= 1.0.0` installed.
- ☁️ **Azure CLI**: Installed and authenticated via `az login`.
- 🔑 **Azure Subscription**: Access with appropriate permissions (e.g., Contributor or Owner).
- 🔐 **SSH Key Pair**: Local SSH public key at `~/.ssh/id_rsa.pub` (required for VM deployment).

---

## 🛠️ Usage & Deployment Guide 🚀

### 🧪 Deploying the Pre-production Environment

1. 📂 **Navigate to the environment directory**:
   ```bash
   cd environment/preprod
   ```

2. 🚀 **Initialize Terraform**:
   Initialize backend and download required AzureRM provider plugins:
   ```bash
   terraform init
   ```

3. 🔍 **Preview Infrastructure Changes**:
   Generate an execution plan to inspect resources to be created:
   ```bash
   terraform plan
   ```

4. ⚡ **Apply Infrastructure Provisioning**:
   Provision Azure cloud infrastructure:
   ```bash
   terraform apply
   ```

5. 🧹 **Destroy Environment (Clean Up)**:
   Tear down and remove all provisioned resources:
   ```bash
   terraform destroy
   ```

---

## ⚙️ Environment Configuration 📝

Below is an example configuration snippet from `environment/preprod/terraform.tfvars`:

```hcl
# 🕸️ Subnet Configurations
subnets = {
  snet1 = {
    subnet_name      = "fontend-prod"
    address_prefixes = ["10.0.0.0/24"]
  }
  snet2 = {
    subnet_name      = "backend-prod"
    address_prefixes = ["10.0.1.0/24"]
  }
}

# 🔌 Public IP Configurations
public_ip = {
  public-ip1 = {
    public_ip_name    = "frontend-pip"
    allocation_method = "Static"
  }
  public-ip2 = {
    public_ip_name    = "backend-pip"
    allocation_method = "Static"
  }
}

# 🖥️ Virtual Machine Configurations
virtual_machine = {
  vm1 = {
    vm_name        = "frontend-vm"
    admin_username = "devopsinsider"
    admin_password = "SecretPassword123!"
    nic_name       = "frontend-nic"
    public_ip_name = "frontend-pip"
    subnet_name    = "fontend-prod"
  }
  vm2 = {
    vm_name        = "backend-vm"
    admin_username = "devopsinsider"
    admin_password = "SecretPassword123!"
    nic_name       = "backend-nic"
    public_ip_name = "backend-pip"
    subnet_name    = "backend-prod"
  }
}
```

---

## 🔐 Best Practices & Security 🛡️

- 🔒 **Secrets Management**: Avoid committing sensitive secrets or plain-text passwords in `terraform.tfvars`. Use Azure Key Vault or environment variables (`TF_VAR_*`).
- 💾 **Remote State Storage**: Store Terraform state files in an Azure Blob Storage container with state locking enabled for team collaboration.
- 🔑 **SSH Key Security**: Protect SSH private keys used for virtual machine access.
- 🎯 **Least Privilege**: Grant minimal required Azure RBAC roles for terraform execution service principals.


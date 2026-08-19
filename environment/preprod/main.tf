module "resource_group"{
  source="../../module/azure_resource_gr"
    } 
module "virtual_network"{
    depends_on = [module.resource_group]
    source = "../../module/azure_vnet"
         }

module "subnet"{
    depends_on = [module.virtual_network]
    subnets = var.subnets
    source="../../module/azure_subnet"
 
}
module"public_ip"{
    depends_on = [module.resource_group]
    public_ip=var.public_ip
    source="../../module/azure_pip"
    
}
module "virtual_machine"{
    source = "../../module/azure_vm"
    depends_on = [module.public_ip, module.subnet]
    virtual_machine= var.virtual_machine
}
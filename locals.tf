locals {
  tags = {
    environment = "prod"
    managed_by  = "terraform"
  }

  # Include all VMs (no filter)
  all_vms = {
    for res in data.azurerm_resources.vms.resources :
    "${res.resource_group_name}-${res.name}" => {
      name                = res.name
      resource_group_name = res.resource_group_name
    }
  }
}
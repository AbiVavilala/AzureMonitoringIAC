# Step 1: Get all VM resources in the subscription
data "azurerm_resources" "vms" {
  type = "Microsoft.Compute/virtualMachines"
}

# Step 2: Get VM details (needed for ID and RG)
data "azurerm_virtual_machine" "vm_details" {
  for_each = local.all_vms

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Step 3: Create CPU alerts for all VMs
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  for_each = data.azurerm_virtual_machine.vm_details

  name                = "cpu-usage-${each.value.name}"
  resource_group_name = each.value.resource_group_name
  scopes              = [each.value.id]
  description         = "CPU usage alert > ${var.cpu_threshold}% for ${each.value.name}"
  severity            = 3
  enabled             = true
  frequency           = var.frequency
  window_size         = var.window_size

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.cpu_threshold
  }

  tags = local.tags
}

# alert for VM memory

resource "azurerm_monitor_metric_alert" "VM_Available_Memory_Percentage" {
  for_each = data.azurerm_virtual_machine.vm_details

  name                = "${each.value.name}-availabile_memory-alert"
  resource_group_name = each.value.resource_group_name
  scopes              = [each.value.id]
  description         = "Amount of physical memory, in percentage, availabble for ${each.value.name}"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold         = 90

 
  }
}


# alert for VM availability 

resource "azurerm_monitor_metric_alert" "VM_Availability" {
  for_each = data.azurerm_virtual_machine.vm_details

  name                = "${each.value.name}-availability"
  resource_group_name = each.value.resource_group_name
  scopes              = [each.value.id]
  description         = "VM availability"
  severity            = 4
  frequency           = "PT30M"
  window_size         = "PT30M"
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "VmAvailabilityMetric"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold         = 1

 
  }
}


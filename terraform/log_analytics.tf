# Random suffix for workspace so that the name is unique each time.
# This prevents errors caused by a workspace sharing a name with a deleted resource which Azure thinks still exists.
resource "random_id" "rand" {
  byte_length = 4
}

# Create Log analytics workspaces
resource "azurerm_log_analytics_workspace" "log-analytics" {
  count               = var.workspace_count
  name                = "la-${lower(random_id.rand.hex)}-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
}

# Deploy Sentinel
resource "azurerm_log_analytics_solution" "sentinel" {
  count                 = var.workspace_count
  solution_name         = "SecurityInsights"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  workspace_resource_id = azurerm_log_analytics_workspace.log-analytics[count.index].id
  workspace_name        = azurerm_log_analytics_workspace.log-analytics[count.index].name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }

  depends_on            = [azurerm_log_analytics_workspace.log-analytics]
}

# Deploy Microsoft Monitoring Agents to workstations
resource "azurerm_virtual_machine_extension" "mma-workstation" {
  count                = length(local.domain.workstations)
  name                 = "MicrosoftMonitoringAgent"
  virtual_machine_id   = azurerm_virtual_machine.workstation[count.index].id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"
  settings             = <<SETTINGS
    {
      "workspaceId": "${azurerm_log_analytics_workspace.log-analytics[0].workspace_id}"
    }
  SETTINGS
  protected_settings   = <<PROT
    {
      "workspaceKey": "${azurerm_log_analytics_workspace.log-analytics[0].primary_shared_key}"
    }
  PROT

  depends_on = [
    azurerm_virtual_machine.workstation
  ]
}

# Deploy Microsoft Monitoring Agents to DC
resource "azurerm_virtual_machine_extension" "mma-dc" {
  name                 = "MicrosoftMonitoringAgent"
  virtual_machine_id   = azurerm_virtual_machine.dc.id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"
  settings             = <<SETTINGS
    {
      "workspaceId": "${azurerm_log_analytics_workspace.log-analytics[0].workspace_id}"
    }
  SETTINGS
  protected_settings   = <<PROT
    {
      "workspaceKey": "${azurerm_log_analytics_workspace.log-analytics[0].primary_shared_key}"
    }
  PROT

  depends_on = [
    azurerm_virtual_machine.dc
  ]
}

# Enable the Security Events connector (Required to use SecurityEvent table)
resource "azurerm_resource_group_template_deployment" "security_events" {
  name                       = "security_events"
  resource_group_name        = azurerm_resource_group.main.name
  deployment_mode            = "Incremental"
  template_content           = file("${path.root}/files/arm_templates/security_events.json")
  parameters_content         = jsonencode({
    "workspaceName"          = {
      value                  = "${azurerm_log_analytics_workspace.log-analytics[0].name}"
    },
    "securityCollectionTier" = {
      value                  = "All"
    },
    "location"               = {
      value                  = "${azurerm_log_analytics_workspace.log-analytics[0].location}"
    }
  })

  depends_on                 = [null_resource.install_tools_on_workstation] // Do this towards the end to reduce logs ingested during deployment

  lifecycle {
    ignore_changes           = all
  }
}

# Enable collection for other log channels
resource "azurerm_log_analytics_datasource_windows_event" "channel" {
  count               = length(var.log_channels)

  name                = "${var.log_channels[count.index].name}-channel"
  resource_group_name = azurerm_resource_group.main.name
  workspace_name      = azurerm_log_analytics_workspace.log-analytics[0].name
  event_log_name      = var.log_channels[count.index].event_log_name
  event_types         = var.log_channels[count.index].event_types

  lifecycle {
  ignore_changes      = all
  }

  depends_on          = [null_resource.install_tools_on_workstation] // Do this stuff towards the end to reduce logs for setup activity
  
}

# Deploy ASim parsers
resource "azurerm_resource_group_template_deployment" "asim" {
  name                       = "asim"
  resource_group_name        = azurerm_resource_group.main.name
  deployment_mode            = "Incremental"
  template_content           = file("${path.root}/files/arm_templates/asim.json")
  parameters_content         = jsonencode({
    "workspaceName"          = {
      value                  = "${azurerm_log_analytics_workspace.log-analytics[0].name}"
    },
    "location"               = {
      value                  = "${azurerm_log_analytics_workspace.log-analytics[0].location}"
    }
  })

  depends_on                 = [azurerm_log_analytics_workspace.log-analytics]

  lifecycle {
    ignore_changes           = all
  }
}

# Deploy parsers on the main workspace
resource "azurerm_log_analytics_saved_search" "import_parsers" {
  count                      = length(var.parsers)

  name                       = var.parsers[count.index].name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log-analytics[0].id
  category                   = "Parsers"
  display_name               = var.parsers[count.index].display_name
  query                      = replace(file("${path.root}/files/parsers/${var.parsers[count.index].file_name}"),"WORKSPACE_NAME",azurerm_log_analytics_workspace.log-analytics[0].name)
  function_alias             = var.parsers[count.index].function_alias

  lifecycle {
  ignore_changes             = all
  }

  depends_on                 = [azurerm_log_analytics_workspace.log-analytics]
}

# Deploy CombinedEvents parser on all workspaces
resource "azurerm_log_analytics_saved_search" "combined_events" {
  count                      = var.workspace_count

  name                       = "Combine Event Tables"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log-analytics[count.index].id
  category                   = "Parsers"
  display_name               = "CombinedEvent"
  query                      = replace(file("${path.root}/files/parsers/combined_event.txt"),"WORKSPACE_NAME",azurerm_log_analytics_workspace.log-analytics[0].name)
  function_alias             = "CombinedEvent"

  lifecycle {
  ignore_changes             = all
  }

  depends_on                 = [azurerm_log_analytics_workspace.log-analytics]
}

# Create Sentinel alert rules from custom KQL queries (non-sigma)
resource "azurerm_sentinel_alert_rule_scheduled" "alert_rules_kql" {

  for_each = local.custom_kql

  name                       = "${replace("${each.key}",".kql","")}"
  log_analytics_workspace_id = length(tolist(local.converted_rules)) > 512 ? azurerm_log_analytics_solution.sentinel[1].workspace_resource_id : azurerm_log_analytics_solution.sentinel[0].workspace_resource_id
  display_name               = title(yamldecode(file("${path.root}/files/custom_kql/${replace("${each.key}",".kql",".yml")}"))["title"])
  severity                   = replace(title(yamldecode(file("${path.root}/files/custom_kql/${replace("${each.key}",".kql",".yml")}"))["level"]),"Critical","High")
  description                = yamldecode(file("${path.root}/files/custom_kql/${replace("${each.key}",".kql",".yml")}"))["description"]
  query                      = tostring(replace(file("${path.root}/files/custom_kql/${each.key}"), "/^/", "workspace('${azurerm_log_analytics_workspace.log-analytics[0].name}')."))
  query_frequency            = "PT5M"
  query_period               = "PT5M"
  suppression_duration       = "PT5M"
  trigger_operator           = "GreaterThan"
  enabled                    = true
  suppression_enabled        = false
  trigger_threshold          = 0

  depends_on = [azurerm_virtual_machine_extension.mma-workstation]
}

# Create Sentinel alert rules using the converted sigma rules
resource "azurerm_sentinel_alert_rule_scheduled" "alert_rules_sigma" {

  for_each = local.converted_rules

  name                       = "${replace("${each.key}",".rule","")}"
  log_analytics_workspace_id = index(tolist(local.converted_rules), each.key) > 512 ? azurerm_log_analytics_solution.sentinel[1].workspace_resource_id : azurerm_log_analytics_solution.sentinel[0].workspace_resource_id
  display_name               = title(yamldecode(file("${path.root}/files/sigma/converted/${replace("${each.key}",".rule",".yml")}"))["title"])
  severity                   = replace(title(yamldecode(file("${path.root}/files/sigma/converted/${replace("${each.key}",".rule",".yml")}"))["level"]),"Critical","High")
  description                = yamldecode(file("${path.root}/files/sigma/converted/${replace("${each.key}",".rule",".yml")}"))["description"]
  query                      = tostring(replace(file("${path.root}/files/sigma/converted/${each.key}"), "/^/", "workspace('${azurerm_log_analytics_workspace.log-analytics[0].name}')."))
  query_frequency            = "PT5M"
  query_period               = "PT5M"
  suppression_duration       = "PT5M"
  trigger_operator           = "GreaterThan"
  enabled                    = true
  suppression_enabled        = false
  trigger_threshold          = 0

  depends_on = [azurerm_sentinel_alert_rule_scheduled.alert_rules_kql]
}
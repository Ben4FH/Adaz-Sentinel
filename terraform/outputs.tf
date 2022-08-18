output "check_logs" {
  value = <<EOF

####################
###  WHAT NEXT?  ###
####################

Check your log analytics workspace to make sure logs are being received.
It may take around 2 minutes for the SecurityEvent table to start to populate.
If the below query returns results for the workstations then you should be fine.

SecurityEvent
| where TimeGenerated >= ago(5m)
| where EventID == "4688"
| summarize count() by Computer
EOF
}

output "dc_public_ip" {
  value = tomap({"`${azurerm_virtual_machine.dc.name}" = azurerm_public_ip.main.ip_address})
}

output "workstations_public_ips" {
  value = zipmap(azurerm_virtual_machine.workstation.*.name, azurerm_public_ip.workstation.*.ip_address)
}
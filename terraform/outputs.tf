output "dc_public_ip" {
  value = azurerm_public_ip.main.ip_address
}

output "workstations_public_ips" {
  value = zipmap(azurerm_virtual_machine.workstation.*.name, azurerm_public_ip.workstation.*.ip_address)
}

output "what_next" {
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

RDP to your domain controller: 
xfreerdp /v:${azurerm_public_ip.main.ip_address} /u:${local.domain.dns_name}\\${local.domain.initial_domain_admin.username} '/p:${local.domain.initial_domain_admin.password}' +clipboard /cert-ignore

RDP to a workstation:
xfreerdp /v:${azurerm_public_ip.workstation[0].ip_address} /u:${local.domain.default_local_admin.username} '/p:${local.domain.default_local_admin.password}' +clipboard /cert-ignore

EOF
}
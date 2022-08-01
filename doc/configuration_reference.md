# `domain.yml` reference

This page provides reference documentation for the `domain.yml` configuration file used to configure your lab.

Annotated configuration file:

```yaml
# FQDN of your domain
dns_name: hunter.lab

# Hostname & IP of the domain controller
dc_name: DC-1
dc_ip: "10.0.10.10"

# Credentials of the initial domain admin
initial_domain_admin:
  username: hunter
  password: Hunt3r123.

# Organizational Units
organizational_units:
- OU=Workstations
- OU=Accounts
- OU=Roles

# Domain users - by default, password := username
users:
- username: barry
  OU: OU=Accounts
- username: cisco
  password: Cisco123!
  OU: OU=Accounts
- username: iris
  OU: OU=Accounts
- username: caitlin
  OU: OU=Accounts

# Domain groups and members assigned
groups:
- dn: CN=Hunters,OU=Roles
  members: [barry, iris]

# Credentials of the local admin created on all workstations
default_local_admin:
  username: localadmin
  password: Localadmin!

# Workstations to create and to domain-join, as well as the local admins on these workstations.
workstations:
- name: BARRY-WKS
  local_admins: [barry]
- name: IRIS-WKS
  local_admins: [iris]

# Should the Windows firewall be enabled?
enable_windows_firewall: no
```
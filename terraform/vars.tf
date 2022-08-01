variable "domain_config_file" {
  description = "Path to the domain configuration file"
  default     = "../domain.yml"
}

variable "servers_subnet_cidr" {
  description = "CIDR to use for the Servers subnet"
  default     = "10.0.10.0/24"
}

variable "workstations_subnet_cidr" {
  description = "CIDR to use for the Workstations subnet"
  default     = "10.0.11.0/24"
}

variable "region" {
  description = "Azure region in which resources should be created. See https://azure.microsoft.com/en-us/global-infrastructure/locations/"
  default     = "West Europe"
}

variable "resource_group" {
  # Read the FAQ before changing this
  description = "Resource group in which resources should be created. Will automatically be created and should not exist prior to running Terraform"
  default     = "ad-hunting-lab"
}

variable "dc_vm_size" {
  description = "Size of the Domain Controller VM. See https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-sizes-specs"
  default     = "Standard_D1_v2"
}

variable "workstations_vm_size" {
  description = "Size of the workstations VMs. See https://docs.microsoft.com/en-us/azure/cloud-services/cloud-services-sizes-specs"
  default     = "Standard_D1_v2"
}

variable "log_channels" {
  description = "List of event channels to forward logs to Log Analytics"
  default = [
    {
        name           = "sysmon"
        event_log_name = "Microsoft-Windows-Sysmon/Operational"
        event_types    = ["Error","Warning","Information"]
    },
    {
        name           = "directory-service"
        event_log_name = "Directory Service"
        event_types    = ["Error","Warning","Information"]
    },
    {
        name           = "powershell"
        event_log_name = "Windows Powershell"
        event_types    = ["Error","Warning","Information"]
    },
    {
        name           = "powershell-operational"
        event_log_name = "Microsoft-Windows-PowerShell/Operational"
        event_types    = ["Error","Warning","Information"]
    },
    {
        name           = "wmi"
        event_log_name = "Microsoft-Windows-WMI-Activity/Operational"
        event_types    = ["Error","Warning","Information"]
    },
    {
        name           = "system"
        event_log_name = "System"
        event_types    = ["Error","Warning","Information"]
    },
    {
        name           = "rcm"
        event_log_name = "Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational"
        event_types    = ["Error","Warning","Information"]
    },
    {
        name           = "lsm"
        event_log_name = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"
        event_types    = ["Error","Warning","Information"]
    },
    {
        name           = "bits"
        event_log_name = "Microsoft-Windows-Bits-Client/Operational"
        event_types    = ["Error","Warning","Information"]
    },
    {
        name           = "dns-client"
        event_log_name = "Microsoft-Windows-DNS-Client/Operational"
        event_types    = ["Error","Warning","Information"]
    },
    {
        name           = "firewall"
        event_log_name = "Microsoft-Windows-Windows Firewall With Advanced Security/Firewall"
        event_types    = ["Error","Warning","Information"]
    },
    {
        name           = "defender"
        event_log_name = "Microsoft-Windows-Windows Defender/Operational"
        event_types    = ["Information","Error","Warning"]
    }]
}

variable "workspace_count" {
  description = "Number of log analytics workspaces to deploy"
  default     = 2
}

variable "parsers" {
  description = "Details of the parsing functions to create in log analytics"
  default = [
    {
        name                       = "Sysmon Parser"
        display_name               = "SysmonParsed"
        file_name                  = "sysmon_parser.txt"
        function_alias             = "SysmonEvent"
    },
    {
        name                       = "Powershell Parser"
        display_name               = "PowershellParsed"
        file_name                  = "powershell_parser.txt"
        function_alias             = "PSEvent"
    },
    {
        name                       = "SCM Parser"
        display_name               = "ServiceParser"
        file_name                  = "scm_parser.txt"
        function_alias             = "ServiceEvent"
    },
    {
        name                       = "Bits Client Parser"
        display_name               = "BitsClientParser"
        file_name                  = "bits_client_parser.txt"
        function_alias             = "BitsEvent"
    },
    {
        name                       = "Other Event Parser"
        display_name               = "OtherEventParser"
        file_name                  = "other_event_parser.txt"
        function_alias             = "OtherEvent"
    }
  ]
}
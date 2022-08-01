Start-Transcript -path C:\GPO_Backups\script_log.txt -append

Import-Module ActiveDirectory            
Import-Module GroupPolicy  

# Create PSCredential to be used for Enter-PSSession

$domain = Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select -ExpandProperty Domain
$username = "$domain\$($args[0])"
$password = ConvertTo-SecureString $args[1] -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

$backupDir = "C:\GPO_Backups\"
$gpoFolders = @(@("$backupDir\DC-Auditing","Domain Controllers"),@("$backupDir\Workstation-Auditing","Workstations"),@("$backupDir\User-Experience","Accounts"))

# Import GPOs and link them to their associated OU as specified above

Write-Host "Importing and linking GPOs"
foreach ($folder in $gpoFolders){
    $import_array = get-childitem $folder[0] -Directory | Select name
    $ou = "ou=$($folder[1]),dc=$($domain.split(".")[0]),dc=$($domain.split(".")[1])" 
    foreach ($ID in $import_array) {
        $XMLFile = $folder[0] + "\" + $ID.Name + "\gpreport.xml"
        $XMLData = [XML](get-content $XMLFile)
        $GPOName = $XMLData.GPO.Name
        Import-GPO -BackupId $ID.Name -TargetName $GPOName -path $folder[0] -CreateIfNeeded
        New-GPLink -Name $GPOName -Target $ou -LinkEnabled Yes -Enforced Yes -Order 1
    }
}

# Run GPUpdate on all domain joined hosts

Write-Host "Forcing domain wide group policy update"
$hosts = Get-ADComputer -Filter *
$session = New-PSSession -cn $hosts.name -Credential $psCred
Invoke-Command -Session $session -ScriptBlock {gpupdate /force} 

Stop-Transcript 
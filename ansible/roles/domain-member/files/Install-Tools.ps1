$ErrorActionPreference = "Continue"
$installPath = "C:\Tools"

Add-Type -Assembly 'System.IO.Compression.FileSystem'

# Force use of TLS 1.2 because TLS 1.0 does not work with web requests
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "Downloading and running ShutUp10"
$shutUp10DownloadUrl = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"
(New-Object System.Net.WebClient).DownloadFile($shutUp10DownloadUrl, "$installPath\OOSU10.exe")
Invoke-Expression "$installPath\OOSU10.exe $installPath\ooshutup10.cfg /quiet /force"

Write-Host "Downloading Sysinternals"
$sysinternalsUrl = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
$sysinternalsDir = "$installPath\Sysinternals"
New-Item -ItemType Directory -Force -Path $sysinternalsDir

(New-Object System.Net.WebClient).DownloadFile($sysinternalsUrl, "$env:temp\sysinternals")
[System.IO.Compression.ZipFile]::ExtractToDirectory("$env:temp\sysinternals", $sysinternalsDir)

Write-Host "Installing Chocolatey & Apps"
Invoke-Expression (Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing)
$apps = @("NotepadPlusPlus","GoogleChrome","Firefox","7zip","wireshark")
foreach($app in $apps){
    choco install -y $app
} 

Write-Host "Installing Invoke-AtomicRedTeam"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Scope AllUsers -Force
Install-Module -Name powershell-yaml -Scope AllUsers -Force
Invoke-Expression (Invoke-WebRequest 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing);
Install-AtomicRedTeam -InstallPath "$installPath\AtomicRedTeam" -getAtomics -Force

Write-Host "Setting Powershell Profile"
if (!(Test-Path -Path $PROFILE. AllUsersAllHosts)) {
    New-Item -ItemType File -Path $PROFILE.AllUsersAllHosts -Force
}
Copy-Item C:\Tools\PSProfileConfig.ps1 $PROFILE.AllUsersAllHosts -Force

Write-Host "Cleaning Up"
Remove-Item $env:windir\Temp\* -Recurse -Force
Remove-Item $env:temp\* -Recurse -Force
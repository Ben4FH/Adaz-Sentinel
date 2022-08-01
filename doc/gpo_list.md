Below is a list of GPOs being applied. These were mostly taken from Chris Long's [DetectionLab](https://github.com/clong/DetectionLab):

# DC-Auditing

|Policy Target|Subcategory                                 |Inclusion Setting  |
|-------------|--------------------------------------------|-------------------|
|System       |Audit Credential Validation                 |Success and Failure|
|System       |Audit Kerberos Authentication Service       |Success and Failure|
|System       |Audit Kerberos Service Ticket Operations    |Success and Failure|
|System       |Audit Other Account Logon Events            |Success and Failure|
|System       |Audit Computer Account Management           |Success and Failure|
|System       |Audit Distribution Group Management         |Success and Failure|
|System       |Audit Other Account Management Events       |Success and Failure|
|System       |Audit Security Group Management             |Success and Failure|
|System       |Audit User Account Management               |Success and Failure|
|System       |Audit DPAPI Activity                        |Success and Failure|
|System       |Audit PNP Activity                          |Success and Failure|
|System       |Audit Process Creation                      |Success and Failure|
|System       |Audit Process Termination                   |Success and Failure|
|System       |Audit Detailed Directory Service Replication|Success and Failure|
|System       |Audit Directory Service Access              |Success and Failure|
|System       |Audit Directory Service Changes             |Success and Failure|
|System       |Audit Directory Service Replication         |Success and Failure|
|System       |Audit Account Lockout                       |Success and Failure|
|System       |Audit User / Device Claims                  |Success and Failure|
|System       |Audit Group Membership                      |Success and Failure|
|System       |Audit Logoff                                |Success and Failure|
|System       |Audit Logon                                 |Success and Failure|
|System       |Audit Other Logon/Logoff Events             |Success and Failure|
|System       |Audit Special Logon                         |Success and Failure|
|System       |Audit Detailed File Share                   |Success and Failure|
|System       |Audit File Share                            |Success and Failure|
|System       |Audit File System                           |Success and Failure|
|System       |Audit Filtering Platform Connection         |Success and Failure|
|System       |Audit Kernel Object                         |Success and Failure|
|System       |Audit Registry                              |Success and Failure|
|System       |Audit Removable Storage                     |Success and Failure|
|System       |Audit Audit Policy Change                   |Success and Failure|
|System       |Audit Authentication Policy Change          |Success and Failure|
|System       |Audit MPSSVC Rule-Level Policy Change       |Success and Failure|
|System       |Audit Non Sensitive Privilege Use           |Success and Failure|
|System       |Audit Sensitive Privilege Use               |Success and Failure|
|System       |Audit IPsec Driver                          |Success and Failure|
|System       |Audit Other System Events                   |Success and Failure|
|System       |Audit Security State Change                 |Success and Failure|
|System       |Audit Security System Extension             |Success and Failure|
|System       |Audit System Integrity                      |Success and Failure|

# Workstation-Auditing

|Policy Target|Subcategory                                 |Inclusion Setting  |
|-------------|--------------------------------------------|-------------------|
|System       |Audit Credential Validation                 |Success and Failure|
|System       |Audit Other Account Logon Events            |Success and Failure|
|System       |Audit Security Group Management             |Success and Failure|
|System       |Audit User Account Management               |Success and Failure|
|System       |Audit DPAPI Activity                        |Success and Failure|
|System       |Audit PNP Activity                          |Success and Failure|
|System       |Audit Process Creation                      |Success and Failure|
|System       |Audit Process Termination                   |Success and Failure|
|System       |Audit Account Lockout                       |Success and Failure|
|System       |Audit User / Device Claims                  |Success and Failure|
|System       |Audit Group Membership                      |Success and Failure|
|System       |Audit Logoff                                |Success and Failure|
|System       |Audit Logon                                 |Success and Failure|
|System       |Audit Other Logon/Logoff Events             |Success and Failure|
|System       |Audit Special Logon                         |Success and Failure|
|System       |Audit Detailed File Share                   |Success and Failure|
|System       |Audit File Share                            |Success and Failure|
|System       |Audit File System                           |Success and Failure|
|System       |Audit Filtering Platform Connection         |Success and Failure|
|System       |Audit Other Object Access Events            |Success and Failure|
|System       |Audit Registry                              |Success and Failure|
|System       |Audit Removable Storage                     |Success and Failure|
|System       |Audit Audit Policy Change                   |Success and Failure|
|System       |Audit Authentication Policy Change          |Success and Failure|
|System       |Audit MPSSVC Rule-Level Policy Change       |Success and Failure|
|System       |Audit Other Policy Change Events            |Success and Failure|
|System       |Audit Sensitive Privilege Use               |Success and Failure|
|System       |Audit Other System Events                   |Success and Failure|
|System       |Audit Security State Change                 |Success and Failure|
|System       |Audit Security System Extension             |Success and Failure|
|System       |Audit System Integrity                      |Success and Failure|

# User-Experience

## Registry Changes

|Properties/_hive  |Properties/_key                                 |Properties/_name        |Properties/_type|Properties/_value|
|------------------|------------------------------------------------|------------------------|----------------|-----------------|
|HKEY_CURRENT_USER |SOFTWARE\Microsoft\Windows\CurrentVersion\Search|SearchboxTaskbarMode    |REG_DWORD       |00000000         |
|HKEY_LOCAL_MACHINE|SOFTWARE\Policies\Microsoft\Windows\OOBE        |DisablePrivacyExperience|REG_DWORD       |00000001         |

## Desktop Shortcuts

|_name          |Properties/_targetPath                                     |
|---------------|-----------------------------------------------------------|
|Tools          |C:\Tools                                                   |
|Powershell     |%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe|
|Command Prompt |%SystemRoot%\System32\cmd.exe                              |
|Registry Editor|%SystemRoot%\System32\regedit.exe                          |
|Event Viewer   |%SystemRoot%\System32\eventvwr.exe                         |

## Taskbar Layout

|_DesktopApplicationLinkPath                                                                     |
|------------------------------------------------------------------------------------------------|
|%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk                  |
|%APPDATA%\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk       |
|%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\Command Prompt.lnk                 |
|%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk                       |
|%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Notepad++.lnk                           |
|%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Administrative Tools\Event Viewer.lnk   |
|%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Administrative Tools\services.lnk       |
|%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Administrative Tools\Registry Editor.lnk|
|%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Wireshark.lnk                           |
|C:\Tools\Sysinternals\Autoruns64.exe                                                            |
|C:\Tools\Sysinternals\Procmon64.exe                                                             |
|C:\Tools\Sysinternals\procexp64.exe                                                             |
|C:\Tools\Sysinternals\tcpview64.exe                                                             |

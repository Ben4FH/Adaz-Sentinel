Import-Module "C:\Tools\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psm1"
$PSDefaultParameterValues = @{"Invoke-AtomicTest:PathToAtomicsFolder"="C:\Tools\AtomicRedTeam\atomics"}
Set-Location C:\Tools
#Clear-Host
    
function Prompt {
    if ( Test-Path Variable:Global:RedactPreviousLine ) { 
        $cursor = New-Object System.Management.Automation.Host.Coordinates
        $cursor.X = $host.ui.rawui.CursorPosition.X
        $cursor.Y = $host.ui.rawui.CursorPosition.Y - 1
        $host.ui.rawui.CursorPosition = $cursor
        Write-host $( " " * ( $host.ui.RawUI.WindowSize.Width - 1 ) )
        $host.ui.rawui.CursorPosition = $cursor

        Remove-Variable RedactPreviousLine -scope global
    } 
   "[$(Get-Date -Format 'dd/MM/yy HH:mm:ss')] | $(Get-Location) > "
}
$global:RedactPreviousLine = $True

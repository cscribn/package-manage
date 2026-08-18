[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Import-Module "$PSScriptRoot\Private\WingetUtils.psm1" -Force

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"

# winget
Install-WinGetPackageClean -Id Lenovo.SystemUpdate
Install-WinGetPackageClean -Id NextDNS.NextDNS

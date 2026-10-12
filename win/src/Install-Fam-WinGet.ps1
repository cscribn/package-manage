[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Import-Module "$PSScriptRoot\Private\WingetUtils.psm1" -Force

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"

. $PSScriptRoot\Private\Install-Programs-WinGet.ps1
. $PSScriptRoot\Private\Install-Apps-WinGet.ps1

# winget
Install-WinGetPackageClean -Id Lenovo.SystemUpdate
Install-WinGetPackageClean -Id NextDNS.NextDNS

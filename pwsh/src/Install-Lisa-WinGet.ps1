[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Import-Module "$PSScriptRoot\Private\WingetUtils.psm1" -Force

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"

. $PSScriptRoot\Private\Install-Programs-WinGet.ps1
. $PSScriptRoot\Private\Install-Apps-WinGet.ps1

# winget
Install-WinGetPackageClean -Id BlueStack.BlueStacks
Install-WinGetPackageClean -Id fotor.fotor
Install-WinGetPackageClean -Id Google.GoogleDrive
Install-WinGetPackageClean -Id KDE.Krita
Install-WinGetPackageClean -Id NextDNS.NextDNS
Install-WinGetPackageClean -Id Poly.PlantronicsHub

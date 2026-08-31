[CmdletBinding()]
$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'

Import-Module "$PSScriptRoot\..\..\src\Private\WingetUtils.psm1" -Force

Write-Information "Reproducing upgrade-only flow."
Install-WinGetPackageClean -Id 'Microsoft.PowerShell' -InstallType 'UpgradeOnly'

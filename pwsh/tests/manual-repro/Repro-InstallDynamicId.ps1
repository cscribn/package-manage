[CmdletBinding()]
$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'

Import-Module "$PSScriptRoot\..\..\src\Private\WingetUtils.psm1" -Force

Write-Information "Reproducing dynamic-id install flow."
Install-WinGetPackageClean -Id 'EclipseAdoptium.Temurin' -InstallType 'DynamicId' -Like '*JDK*'

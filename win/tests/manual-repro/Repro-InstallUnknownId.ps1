[CmdletBinding()]
$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'

Import-Module "$PSScriptRoot\..\..\src\Private\WingetUtils.psm1" -Force

Write-Information "Reproducing unknown-id install flow."
Install-WinGetPackageClean -Id 'Python.Python.' -InstallType 'UnknownId'

[CmdletBinding()]
$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'

Import-Module "$PSScriptRoot\..\..\src\Private\WingetUtils.psm1" -Force

Write-Information "Reproducing skip-if-installed flow."
Install-WinGetPackageClean -Id 'Microsoft.VisualStudioCode' -InstallType 'SkipIfInstalled'

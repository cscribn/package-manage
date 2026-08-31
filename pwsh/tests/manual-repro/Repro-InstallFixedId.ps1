[CmdletBinding()]
$InformationPreference = 'Continue'
$ErrorActionPreference = 'Stop'

Import-Module "$PSScriptRoot\..\..\src\Private\WingetUtils.psm1" -Force

Write-Information "Reproducing fixed-id install flow."
Install-WinGetPackageClean -Id 'Git.Git' -InstallType 'FixedId'


[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Import-Module "$PSScriptRoot\..\src\Private\WingetUtils.psm1" -Force

Install-WinGetPackageClean -Id "Python.Python." -InstallType "UnknownId"

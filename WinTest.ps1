
[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Import-Module "$PSScriptRoot\WingetUtils.psm1" -Force

Install-WinGetPackageClean -Id "Python.Python." -InstallType "UnknownId"

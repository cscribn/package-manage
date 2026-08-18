
[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Import-Module "$PSScriptRoot\..\src\Private\WingetUtils.psm1" -Force

Invoke-WinGetUninstallWithFallback -Id "KDE.KMahjongg"

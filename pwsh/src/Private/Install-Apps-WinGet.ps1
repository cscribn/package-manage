[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Import-Module "$PSScriptRoot\WingetUtils.psm1" -Force

# appx
# winget
Install-WinGetPackageClean -Id 9NP83LWLPZ9K # apple devices
Install-WinGetPackageClean -Id 9PKTQ5699M62 # icloud

[CmdletBinding()]
$Global:InformationPreference = 'Continue'

Import-Module "$PSScriptRoot\Private\WingetUtils.psm1" -Force

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"

# winget
Install-WinGetPackageClean -Id DBBrowserForSQLite.DBBrowserForSQLite
Install-WinGetPackageClean -Id Google.GoogleDrive
Install-WinGetPackageClean -Id PaperCutSoftware.MobilityPrint
Install-WinGetPackageClean -Id NextDNS.NextDNS
Install-WinGetPackageClean -Id Plex.PlexMediaServer -InstallType "SkipIfInstalled"

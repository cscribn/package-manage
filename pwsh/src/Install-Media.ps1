# Non-package installations (add/update these first)
# backblaze

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"

. $PSScriptRoot\Private\Set-Registry.ps1
. $PSScriptRoot\Private\Install-Programs.ps1
. $PSScriptRoot\Private\Install-Apps.ps1

# winget
Install-WinGetPackageClean -Id DBBrowserForSQLite.DBBrowserForSQLite
Install-WinGetPackageClean -Id Google.GoogleDrive
Install-WinGetPackageClean -Id PaperCutSoftware.MobilityPrint
Install-WinGetPackageClean -Id NextDNS.NextDNS
Install-WinGetPackageClean -Id Plex.PlexMediaServer -InstallType SkipIfInstalled

# config

## microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\Private\Copy-Config.ps1
. $PSScriptRoot\Private\Remove-Unwanted.ps1

# cleanup
choco uninstall choco-cleaner -y
. $PSScriptRoot\Private\Reset-Network.ps1

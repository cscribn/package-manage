# Non-package installations (add/update these first)
# backblaze

Get-Date -Format "dddd, MMMM dd, yyyy - hh:mm tt"
. $PSScriptRoot\Private\Install-Programs.ps1

Install-WinGetPackageClean -Id DBBrowserForSQLite.DBBrowserForSQLite
Install-WinGetPackageClean -Id Google.GoogleDrive
Install-WinGetPackageClean -Id PaperCutSoftware.MobilityPrint
Install-WinGetPackageClean -Id NextDNS.NextDNS
Install-WinGetPackageClean -Id Plex.PlexMediaServer -InstallType SkipIfInstalled

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\Private\Remove-Unwanted.ps1

# cleanup
choco upgrade choco-cleaner --params "'/NOTASK:TRUE'" -y --ignore-dependencies; Start-Process -FilePath "C:\ProgramData\chocolatey\bin\choco-cleaner.bat" -Wait

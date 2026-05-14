# Non-package installations (add/update these first)
# backblaze

. $PSScriptRoot\_WinDefaultPrograms.ps1

winget install -e --id DBBrowserForSQLite.DBBrowserForSQLite
winget install -e --id Google.GoogleDrive
winget install -e --id PaperCutSoftware.MobilityPrint
winget install -e --id NextDNS.NextDNS
winget install -e --id Plex.PlexMediaServer

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\_WinDefaultCleanup.ps1

# cleanup
choco upgrade choco-cleaner --params "'/NOTASK:TRUE'" -y --ignore-dependencies; Start-Process -FilePath "C:\ProgramData\chocolatey\bin\choco-cleaner.bat" -Wait

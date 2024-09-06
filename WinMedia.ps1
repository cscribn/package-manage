# Non-package installations (add/update these first)
# backblaze
# plex media server

. $PSScriptRoot\_WinDefaultFirst.ps1

winget install -e --id Dell.CommandUpdate.Universal
winget install -e --id Google.GoogleDrive
winget install -e --id NextDNS.NextDNS.Desktop
winget install -e --id PaperCutSoftware.MobilityPrint

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\_WinDefaultLast.ps1

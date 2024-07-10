# Non-Chocolatey installations (add/update these first)
# alienware update universal
# backblaze
# googledrive
# papercut mobility print

. $PSScriptRoot\_ChocoDefaultFirst.ps1

choco upgrade nextdns -y
choco upgrade plexmediaserver -y

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/config-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\_ChocoDefaultLast.ps1

# Non-package installations (add/update these first)
# alienware update universal
# backblaze
# googledrive
# papercut mobility print

. $PSScriptRoot\_WinDefaultFirst.ps1

choco upgrade nextdns -y
choco upgrade plexmediaserver -y

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\_WinDefaultLast.ps1

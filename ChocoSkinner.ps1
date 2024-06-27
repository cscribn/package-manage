# Non-Chocolatey installations (add/update these first)
# backblaze
# bluestacks
# iso compressor
# skraperui
# spotdl

. $PSScriptRoot\_ChocoDefaultFirst.ps1

choco upgrade barrier -y
choco upgrade docker-desktop -y
choco upgrade dvdflick-v2 -y
choco upgrade makemkv -y
choco upgrade rpi-imager -y
choco upgrade win32diskimager --version 0.9.5 -y
choco pin add --name="'win32diskimager'" --version="'0.9.5'"

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/config-misc/main/microsoft-windows-terminal/LocalState/settings-skinner.json

. $PSScriptRoot\_ChocoDefaultLast.ps1

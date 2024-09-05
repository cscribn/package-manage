# Non-package installations (add/update these first)
# backblaze
# iso compressor
# skraperui
# spotdl

. $PSScriptRoot\_WinDefaultFirst.ps1

choco upgrade barrier -y
winget install -e --id BlueStack.BlueStacks
choco upgrade dbeaver -y
choco upgrade dvdflick-v2 -y
choco upgrade github-desktop -y
winget install -e --id Google.GoogleDrive
choco upgrade hxd -y
choco upgrade kitty -y
choco upgrade makemkv -y
choco upgrade nextdns -y
winget install -e --id Poly.PlantronicsHub # plantronics hub
choco upgrade postman -y
choco upgrade rpi-imager -y
choco upgrade wireguard -y
choco upgrade win32diskimager --version 0.9.5 -y
choco pin add --name="'win32diskimager'" --version="'0.9.5'"

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-chad.json

. $PSScriptRoot\_WinDefaultLast.ps1

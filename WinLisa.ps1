# Non-package installations (add/update these first)
# awesome duplicate photo finder
# backblaze
# google drive
# scansnap
# silhouette studio

. $PSScriptRoot\_WinDefaultFirst.ps1

winget install -e --id BlueStack.BlueStacks
winget install -e --id fotor.fotor
choco upgrade nextdns -y
winget install -e --id Poly.PlantronicsHub # plantronics hub

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"; `
curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/dotfiles-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\_WinDefaultLast.ps1

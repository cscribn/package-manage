# Non-Chocolatey installations (add/update these first)
# awesome duplicate photo finder
# backblaze
# bluestacks
# collageit
# fotor
# scansnap
# silhouette studio

. $PSScriptRoot\_ChocoDefaultFirst.ps1

# config

# microsoft-windows-terminal
$LocalStateDir = Get-ChildItem -Path "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState"

curl -Lo "$LocalStateDir\settings.json" https://raw.githubusercontent.com/cscribn/config-misc/main/microsoft-windows-terminal/LocalState/settings-default.json

. $PSScriptRoot\_ChocoDefaultLast.ps1
